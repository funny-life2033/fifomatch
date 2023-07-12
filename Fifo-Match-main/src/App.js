import "./App.css";
import { BrowserRouter, Route, Routes, useRoutes } from "react-router-dom";
/* import Root from "./components/Root";
import TermsAndCondtions from "./components/TermsAndCondtions";
import PrivacyPolicy from "./components/PrivacyAndPolicy"; */

import CombineRoutes from "./routes/CombineRoutes";

function App() {
  return (
    <>
      <div className="App">
        <CombineRoutes />
      </div>
    </>
  );
}

export default App;
