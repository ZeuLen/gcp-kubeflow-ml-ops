from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split


def data(df):
    features_to_select = ['V14', 'V4', 'V17', 'V10', 'V12', 'V20', 'Amount', 'V21', 'V26', 'V28', 'V11', 'V19', 'V8',
                          'V7', 'V13']

    scaler = StandardScaler()
    df[df.columns[:-1].tolist()] = scaler.fit_transform(df[df.columns[:-1].tolist()])
    X = df[df.columns[:-1].tolist()]
    X = X[features_to_select]
    y = df[df.columns[-1]]

    x_train, x_test, y_train, y_test = train_test_split(X, y, test_size=0.30, random_state=0)
    print(f"X_train shape: {x_train.shape}")
    print(f"y_train shape: {y_train.shape}")

    return x_train, x_test, y_train, y_test
