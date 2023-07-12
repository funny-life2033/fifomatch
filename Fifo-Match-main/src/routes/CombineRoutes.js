import { useRoutes } from "react-router-dom";
// routes
import MainRoutes from "./MainRoutes";

// ==============================|| ROUTING RENDER ||============================== //

export default function CombineRoutes() {
  return useRoutes([MainRoutes], process.env.BASENAME);
}
