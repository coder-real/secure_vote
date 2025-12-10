# SecureVote
### Restoring Trust in Democracy through Immutable Technology

![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Flutter](https://img.shields.io/badge/Flutter-3.0-02569B.svg) ![Blockchain](https://img.shields.io/badge/Blockchain-Ethereum-3C3C3D.svg) ![Status](https://img.shields.io/badge/Status-Undergraduate_Final_Project-success.svg)

---

## 📖 The Story: Why This Exists

The genesis of **SecureVote** lies in the chaotic aftermath of the **2023 Nigerian General Elections**. 

Expectations were high. The Independent National Electoral Commission (INEC) had promised a technological revolution with the **Bimodal Voter Accreditation System (BVAS)** and the **INEC Results Viewing Portal (IReV)**. These tools were meant to be the safeguard against the rigging that had plagued previous eras. 

However, reality painted a different picture:
*   **Technological Failure:** The "real-time" transmission of results to the IReV portal failed spectacularly during the presidential polls, creating a blackout of information that became a breeding ground for conspiracy and distrust.
*   **Violence & Suppression:** In states like Lagos and Rivers, ballot boxes were snatched, and voters were physically intimidated. The physical vulnerability of the paper ballot was exploited to disenfranchise millions.
*   **Erosion of Trust:** With results being collated manually in opaque centers due to technical "glitches," the electorate's confidence in the declared outcomes plummeted.

**SecureVote** was built as a direct response to this systemic failure. 

It asks a simple, radical question: **What if the ballot box was digital, immutable, and visible to everyone?**

This project is not just a voting app; it is a proof-of-concept for a future where:
1.  **Votes are Transactions:** Every vote is a transaction on a blockchain, cryptographically signed and impossible to alter or delete.
2.  **Transparency is Default:** The tally is not calculated in a back room; it is the sum of verifiable transactions on the ledger, visible to any observer.
3.  **Safety is Guaranteed:** Voters cast their ballots from the safety of their mobile devices, removing the risk of physical violence at polling units.

---

## 🏗️ Technical Architecture

SecureVote utilizes a hybrid architecture that bridges the gap between user-friendly mobile experiences and the trustless nature of blockchain technology.

### 1. The Mobile Frontier (Flutter)
The user-facing application is built with **Flutter**, ensuring a smooth, native experience on both Android and iOS.
*   **Biometric Authentication:** Leveraging device security (Fingerprint/FaceID) to ensure that the person holding the phone is the registered voter.
*   **Offline-First Design:** Recognizing Nigeria's unstable internet infrastructure, votes can be securely stored locally using `SharedPreferences` and `SQLite`, then synchronized when connectivity is restored via `Connectivity Plus`.
*   **Real-time Visualization:** Voters don't just hope their vote counted; they see the chain update in real-time.

### 2. The Truth Layer (Blockchain Network)
The core integrity of the system relies on a private Ethereum-based blockchain.
*   **Smart Contract (`VotingContract.sol`):** Written in **Solidity**, this contract governs the election rules. It ensures that:
    *   A voter can only vote once.
    *   Votes can only be cast during the election window.
    *   The vote tally is calculated programmatically, strictly following the logic of the code.
*   **Hardhat:** Used for compiling, testing, and deploying the smart contracts to a local development network.

### 3. The Backend Bridge (Node.js & Express)
A lightweight **Node.js** server acts as the bridge for administrative tasks and heavy data aggregation.
*   **Dashboard:** An HTML/JS dashboard provides electoral commissions with a bird's-eye view of the election progress.
*   **Data Caching:** Uses **SQLite** to cache blockchain data for faster retrieval during high-traffic periods, ensuring the mobile app remains responsive without hammering the blockchain node directly.

---

## 🚀 Features

*   **Immutable Ballot Box:** Votes are stored on the blockchain. Once a transaction is confirmed, it is permanent.
*   **One-Voter-One-Vote:** Smart contract logic enforces strict checks to prevent double voting.
*   **Live Results:** No more waiting for days. As votes are mined into blocks, the results update instantly.
*   **Anti-intimidation:** By allowing remote voting, the system protects voters from the physical violence often seen at polling stations.
*   **Transparency:** Anyone with access to the network can audit the smart contract and the transaction logs.

---

## 🛠️ Installation & Setup

Follow these steps to deploy the entire SecureVote ecosystem locally.

### Prerequisites
*   **Node.js** (v16.0.0 or higher)
*   **Flutter SDK** (v3.0.0 or higher)
*   **Git**

### Step 1: Clone the Repository
```bash
git clone https://github.com/your-username/securevote.git
cd securevote
```

### Step 2: Start the Blockchain Network
Navigate to the blockchain directory, install dependencies, and start the local Hardhat node.

```bash
cd securevote-chain
npm install
npx hardhat node
```
*Keep this terminal running. It is your local blockchain network.*

### Step 3: Deploy the Smart Contract
In a new terminal, deploy the voting contract to your local network.

```bash
cd securevote-chain
npx hardhat run scripts/deploy.ts --network localhost
```
*Note the deployed contract address. You may need to update this in the Flutter app constants.*

### Step 4: Start the Backend Server
Navigate to the backend directory and start the server.

```bash
cd ../voting-backend
npm install
node server.js
```
*The dashboard will be available at `http://localhost:3000/dashboard.html` (check console for exact port).*

### Step 5: Run the Mobile App
Finally, launch the Flutter application. Ensure you have an emulator running or a physical device connected.

```bash
cd ..
flutter pub get
flutter run
```

---

## 🔮 Future Roadmap

*   **Decentralized Identity (DID):** Integration with national identity databases for fully autonomous voter verification.
*   **Zero-Knowledge Proofs (ZK-SNARKs):** To allow voters to prove they voted without revealing *who* they voted for (Privacy + Verifiability).
*   **Mainnet Deployment:** moving from a testnet to a public blockchain like Ethereum or Polygon for global transparency.

---

> "The ballot is stronger than the bullet." — Abraham Lincoln
