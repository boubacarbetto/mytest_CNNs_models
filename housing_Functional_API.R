### regression neural nets with Functional API

#loading the inbuilt dataset
boston_housing <- dataset_boston_housing()

#To
c(train_data, train_labels) %<-% boston_housing$train
c(test_data, test_labels) %<-% boston_housing$test

# Test data is "not" used when calculating the mean ans std.

# Normalize training data
train_data <- scale(train_data)

# use_mean and standard deviations from training set to normalize test set
col_means_train <- attr(train_data, "scaled:center")
col_stddevs_train <- attr(train_data, "scaled:scale")

# functional API has two parts: inputs and outputs
# input layer
inputs <- layer_input(shape = dim(train_data)[2])

# outputs compose input + dense layers
predictions <- inputs %>%
  layer_dense(units = 64, activation = 'relu') %>%
  layer_dense(units = 64, activation = 'relu') %>%
  layer_dense(units = 1)

# create and compile model
model <- keras_model(inputs = inputs, outputs = predictions)
model %>% compile(
  optimizer = 'rmsprop',
  loss = 'mse',
  metrics = list("mean_absolute_error")
)

model %>% fit(train_data, train_labels, epochs = 30, batch_size=100)



# Test Performance

score <- model %>% evaluate(test_data, test_labels)
cat('Test loss',score['loss'], "\n")
cat('Test absolute',score['mean_absolute_error'], "\n")


#-----------------------------------#

# input layer

inputs_func <- layer_input(shape = dim(train_data)[2])

# outputs compose input + dense layers

predictions_func <- inputs_func %>%
  layer_dense(units = 64, activation = 'relu') %>%
  layer_dense(units = 64, activation = 'relu')

# Re-using the input features after the second hidden layer
main_output <- layer_concatenate(c(predictions_func, inputs_func)) %>%
  layer_dense(units = 1)

# create and compile model

model_func <- keras_model(inputs = inputs_func, outputs = main_output)
model_func %>% compile(
  optimizer = 'rmsprop',
  loss = 'mse',
  metrics = list("mean_absolute_error")
)

summary(model_func)
model_func %>% fit(train_data,train_labels, epochs=30, batchsize=100)

# Test Performance

score_func <- model_func %>% evaluate(test_data, test_labels)
cat('Functional Model Test loss:', score_func[["loss"]], "\n")
cat('Normal Model Test loss:', score["loss"], "\n")
#
cat('Functional Model Test Mean Abs Error:', score_func["mean_absolute_error"], "\n")
cat('Normal Model Test Mean Abs Error:', score["mean_absolute_error"], "\n")




######---------------------###############

### Saving and Restore  Models

model_func %>% save_model_hdf5("my_r_model.h5")

new_model <- load_model_hdf5("my_r_model.h5")

model_func %>% summary()
#
new_model %>% summary()



###### Using callbacks to create epoch store points
#create variable
checkpoint_dir <- "checkpoints"
#create folder
dir.create(checkpoint_dir, showWarnings = FALSE)
filepath <- file.path(checkpoint_dir, "Epoch-{epoch:02d}.hdf5")

## Create checkpoint callback
cp_callback <- callback_model_checkpoint(filepath = filepath)
#clean the memory
rm(model_func)
#clear all the background stored in keras library
k_clear_session()

model_callback <- keras_model(inputs = inputs_func, outputs = main_output)
model_callback %>% compile(optimizer = 'rmsprop', loss='mse',
                           metrics = list("mean_absolute_error"))

model_callback %>% fit(train_data, train_labels, epochs = 30,
                       callbacks = list(cp_callback))

list.files(checkpoint_dir)

tenth_model <- load_model_hdf5(file.path(checkpoint_dir, "Epoch-10.hdf5"))
summary(tenth_model)


###### Only Saving the Best model weight

callbacks_best <- callback_model_checkpoint(filepath = "best_r_model.h5",
                                            monitor="val_loss", save_best_only = TRUE)

rm(model_callback)
k_clear_session()

model_cb_best <- keras_model(inputs = inputs_func, outputs = main_output)
model_cb_best %>% compile(optimizer = 'rmsprop', loss='mse',
                          metrics = list("mean_absolute_error"))

model_cb_best %>% fit(train_data, train_labels, epochs = 30,
                       validation_data=list(test_data, test_labels),
                       callbacks = list(callbacks_best))

best_model <- load_model_hdf5("best_r_model.h5")

######### Stopping the processing when we find the best model
## stopping runing when we do not see much improvement of accuracy
## prevent overfitting
callbacks_list <- list(
  callback_early_stopping(monitor = "val_loss", patience = 3),
  callback_model_checkpoint(filepath = "best_r_model_early_stopping.h5", 
                            monitor="val_loss", save_best_only = TRUE)
)

rm(model_cb_best)
k_clear_session()

model_cb_early <- keras_model(inputs = inputs_func, outputs = main_output)
model_cb_early %>% compile(optimizer = 'rmsprop', loss='mse',
                          metrics = list("mean_absolute_error"))

model_cb_early %>% fit(train_data, train_labels, epochs = 100,
                      validation_data=list(test_data, test_labels),
                      callbacks = callbacks_list)

best_model_early_stopping <- load_model_hdf5("best_r_model_early_stopping.h5")
k_clear_session()



#### Data importing 

df <- read.csv("House_Price.csv", header=TRUE)
# gives what kind of data 
str(df)
