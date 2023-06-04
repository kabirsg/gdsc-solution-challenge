import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

class firebaseConnection():
    def __init__():
        # Setup 
        # serviceAccountKey.json is not on github since it is a private key
        self.cred = credentials.Certificate("serviceAccountKey.json")
        firebase_admin.initialize_app(self.cred)
        self.db=firestore.client()
    
    def update(sys_name, bin_num, capacity, deposited):
        # Update data with known key
        bin_capacity = str(bin_num) + "capacity"
        bin_deposited = str(bin_num) + "deposited"
        try:
            db.collection('systems').document(sys_name).update({bin_capacity: capacity}) # updates bin capacity
            db.collection('systems').document(sys_name).update({bin_deposited: deposited}) # updates bin deposited
        except:
            print("Failed. Try adding the system to the app.")
            
if __name__ == "__main__":
    firebase = firebaseConnection()
    firebase.update("EAYtmACasVXqC4f0qqCA", "bin1", "10.8", "1")
