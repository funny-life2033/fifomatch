import { lazy } from "react";

import BaseLayout from "../components/BaseLayout";
import Loadable from "../components/Loader/Loadable";

const Root = Loadable(lazy(() => import("../components/Root")));

const TermsAndConditions = Loadable(lazy(() => import("../components/TermsAndCondtions")));

const PrivacyPolicy = Loadable(lazy(() => import("../components/PrivacyAndPolicy")));

// ==============================|| ROUTING ||============================== //

const MainRoutes = {
  path: "/",
  element: <BaseLayout />,
  children: [
    {
      path: "/",
      element: <Root />,
    },
    {
      path: "/privacy-policy",
      element: <PrivacyPolicy />,
    },
    {
      path: "/term_and_condition",
      element: <TermsAndConditions />,
    },
  ],
};

export default MainRoutes;
