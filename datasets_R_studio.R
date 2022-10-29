fashion_mnist <- dataset_fashion_mnist()

#test
#train
c(train_images, train_labels) %<-% fashion_mnist$train
c(test_images, test_labels) %<-% fashion_mnist$test

#Explore
dim(train_images)
str(train_images)

#ploting the image
fobject <- train_images[9,,]
plot(as.raster(fobject, max = 255))

class_names = c('T-shirt/top', 'Trouser', 'Pullover','Dress',
                'Coat', 'Sandal','Shirt','Sneaker',
                'Bag', 'Ankle boot')
class_names[train_labels[9]+1]

#normalizing [(x-mean)/std.Dev]
x_train_n <- x_train_full / 255
x_test_n <- x_test / 255

#creating a validation split
val_indices <- 1:5000
val_images <- train_images[val_indices,,]
part_train_images <- train_images[-val_indices,,]
val_labels <- train_labels[val_indices]
part_train_labels <- train_labels[-val_indices]

#flattering
#keras
#install.packages("keras")
#install_keras()
5 + 4
#model <- keras_model_sequential()
model <- keras_model_sequential()
model %>%
  layer_flatten(input_shape = c(28,28)) %>%
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dense(units = 10, activation = 'softmax')

model %>% compile(
  optimizer = 'sgd',
  loss = 'sparse_categorical_crossentropy',
  metrics = c('accuracy')
)

model %>% fit(part_train_images, part_train_labels, epochs = 24, batch_size=100, validation_data=list(val_images, val_labels))

# Test performance
score <- model %>% evaluate(test_images, test_labels)


cat('Test loss:', score["loss"], "\n")
cat('Test accuracy:', score["accuracy"], "\n")

# Predicting on Test
predictions <- model %>% predict(test_images)
predictions[1, ]
which.max(predictions[1, ])
class_names[which.max(predictions[1, ])]
plot(as.raster(test_images[1, , ], max = 255))

model %>% predict(test_images) %>% `>`(0.5) %>% k_cast("int32")
#model %>% predict_classes(test_images)
#model %>% predict_classes(x_test) %>% `>`(0.5) %>% k_cast("int32")
class_pre[1:20]
