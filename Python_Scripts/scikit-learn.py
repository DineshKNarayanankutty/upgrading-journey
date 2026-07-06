from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score

#1 Load the iris dataset
iris = load_iris()
X, y = iris.data, iris.target

#2 Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

#3 Choose amodel and fit it to the training data
model = KNeighborsClassifier(n_neighbors=3)
model.fit(X_train, y_train)

#4 Make predictions on the test set
predictions = model.predict(X_test)

#5 Evaluate the model's accuracy
print(f"Accuracy: {accuracy_score(y_test, predictions) * 100: .2f}%")
