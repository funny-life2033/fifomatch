import { useRef } from "react";
import { useLocation, Link } from "react-router-dom";

const Header = () => {
  const location = useLocation();
  if (location?.state?.from?.includes("about-us")) {
    window.scrollTo({ top: 900, left: 0, behavior: "smooth" });
  }

  if (location?.state?.from?.includes("register")) {
    window.scrollTo({ top: 1800, left: 0, behavior: "smooth" });
  }
  return (
    <header className="py-4 border-b-4 border-orange-600 drop-shadow">
      <div className="container mx-auto">
        <div className="flex items-center justify-between">
          <div className="logo">
            <Link to="/">
              <img src="./assets/images/logo.png" alt="" />
            </Link>
          </div>
          <div className="flex items-center ml-auto">
            <nav className="nav flex flex-wrap items-center justify-between">
              <input
                className="menu-btn hidden"
                type="checkbox"
                id="menu-btn"
              />
              <label
                className="menu-icon block cursor-pointer md:hidden px-2 py-4 relative select-none"
                htmlFor="menu-btn"
              >
                <span className="navicon bg-grey-darkest flex items-center relative"></span>
              </label>

              <ul className="menu border-b md:border-none flex justify-end list-reset m-0 w-full md:w-auto">
                <li className="border-t md:border-none">
                  {/* <Link
                    to={"/"}
                    className="block md:inline-block px-4 py-3 no-underline text-grey-darkest hover:text-orange-600"
                  >
                    Home
                  </Link> */}

                  {location.pathname.includes("/term_and_condition") ||
                    location.pathname.includes("/privacy-policy") ? (
                    <Link
                      to="/"
                      state={{ from: "home" }}
                      className="block md:inline-block px-4 py-3 no-underline text-grey-darkest hover:text-orange-600"
                    >
                      Home
                    </Link>
                  ) : (
                    <a
                      href="/#home"
                      className="block md:inline-block px-4 py-3 no-underline text-grey-darkest hover:text-orange-600"
                    >
                      Home
                    </a>
                  )}
                </li>

                <li className="border-t md:border-none">
                  {location.pathname.includes("/term_and_condition") ||
                    location.pathname.includes("/privacy-policy") ? (
                    <Link
                      to="/#about-section"
                      state={{ from: "about-us" }}
                      className="block md:inline-block px-4 py-3 no-underline text-grey-darkest hover:text-orange-600"
                    >
                      About us
                    </Link>
                  ) : (
                    <a
                      href="/#about-section"
                      className="block md:inline-block px-4 py-3 no-underline text-grey-darkest hover:text-orange-600"
                    >
                      About us
                    </a>
                  )}
                </li>
                <li className="border-t md:border-none">
                  {/* <Link
                    to={"/#contactus"}
                    className="block md:inline-block px-4 py-3 no-underline text-grey-darkest hover:text-orange-600"
                  >
                    
                  </Link> */}

                  {location.pathname.includes("/term_and_condition") ||
                    location.pathname.includes("/privacy-policy") ? (
                    <Link
                      to="/"
                      state={{ from: "register" }}
                      className="block md:inline-block px-4 py-3 no-underline text-grey-darkest hover:text-orange-600"
                    >
                      Contact us
                    </Link>
                  ) : (
                    <a
                      href="/#register"
                      className="block md:inline-block px-4 py-3 no-underline text-grey-darkest hover:text-orange-600"
                    >
                      Contact us
                    </a>
                  )}
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
