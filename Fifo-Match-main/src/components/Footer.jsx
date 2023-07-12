import React from "react";
import { useForm } from "react-hook-form";
import axios from "axios";
import "react-toastify/dist/ReactToastify.css";
import { toast } from "react-toastify";
import { Link } from "react-router-dom";
import { useLocation } from "react-router-dom";

const Footer = () => {
  const location = useLocation();

  const {
    register,
    handleSubmit,
    setValue,
    control,
    watch,
    reset,
    formState: { errors },
  } = useForm();

  const onSubmit = async (data, e) => {
    try {
      const response = await axios.post(
        `${process.env.REACT_APP_API_BASE_URL}newsletter_submit`,
        data
      );
      if (response?.status === 200) {
        toast.success("Successfully subscribe news letter", {
          position: "top-right",
          autoClose: 5000,
          hideProgressBar: false,
          closeOnClick: true,
          pauseOnHover: true,
          draggable: true,
          progress: undefined,
        });
      }
      e.target.reset();
    } catch (error) {
      toast.error("Your email id is already subscribe us", {
        position: "top-right",
        autoClose: 5000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        progress: undefined,
      });
    }
  };

  return (
    <>
      <footer className="bg-cover text-white text-left">
        <div className="top-footer common-border py-5">
          <div className="container mx-auto">
            <div className="grid grid-cols-1 sm:grid-cols-3 md:grid-cols-2 items-center">
              <div className="grid-items sm:col-span-1 text-center sm:text-left mb-3">
                <div>
                  <h2 className="text-2xl lg:text-3xl font-bold">Be Updated</h2>
                  <span className="text-base d-block">
                    With the latest developments & offers
                  </span>
                </div>
              </div>
              <div className="grid-items col-span-2 md:col-span-1">
                <form className="relative" onSubmit={handleSubmit(onSubmit)}>
                  <input
                    type="email"
                    autoComplete="off"
                    className="form-control text-white block w-full px-4 py-2 bg-transparent font-normal bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:outline-none"
                    id="exampleFormControlInput2"
                    placeholder="Your E-mail Address"
                    {...register("email", {
                      required: {
                        value: true,
                        message: "Please enter email address",
                      },
                      pattern: {
                        value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
                        message: "Please enter valid email address.",
                      },
                    })}
                    onChange={(e) =>
                      setValue("email", e.target.value, {
                        shouldValidate: true,
                      })
                    }
                  />
                  {errors?.email?.message && (
                    <p className="text-orange-500 form-error">
                      {errors?.email?.message}
                    </p>
                  )}
                  <button
                    type="submit"
                    className="absolute right-2 py-3 px-4 text-white font-semibold rounded-md shadow-md hover:bg-orange-400 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-opacity-75"
                  >
                    SUBSCRIBE
                  </button>
                </form>
              </div>
            </div>
          </div>
        </div>

        <div className="bottom-footer py-5 common-border">
          <div className="container mx-auto">
            <div className="grid grid-cols-1 sm:grid-cols-2">
              <div className="grid-items mb-4">
                <figure className="my-4">
                  <a href="/">
                    <img src="./assets/images/footer-logo.svg" alt="" />
                  </a>
                </figure>
                <p className="text-[16px] font-light">
                  FIFO Match is a dating app established by FIFO Workers for
                  FIFO Workers. This app has been designed to make it easy to
                  connect.
                </p>
              </div>

              <div className="grid-items grid grid-cols-2">
                <div className="grid-items flex justify-initial sm:justify-center md:justify-end">
                  <div>
                    <h2 className="font-bold mb-3 text-sm sm:text-base">
                      SORT LINKS
                    </h2>
                    <ul className="text-left">
                      <li>
                        {location.pathname.includes("/term_and_condition") ||
                          location.pathname.includes("/privacy-policy") ? (
                          <Link
                            to="/#about-section"
                            state={{ from: "about-us" }}
                            className="text-sm sm:text-base"
                          >
                            About us
                          </Link>
                        ) : (
                          <a
                            href="/#about-section"
                            className="text-sm sm:text-base"
                          >
                            About us
                          </a>
                        )}
                      </li>
                      <li>
                        {location.pathname.includes("/term_and_condition") ||
                          location.pathname.includes("/privacy-policy") ? (
                          <Link
                            to="/"
                            state={{ from: "register" }}
                            className="text-sm sm:text-base"
                          >
                            Contact us
                          </Link>
                        ) : (
                          <a
                            href="/#register"
                            className="text-sm sm:text-base"
                          >
                            Contact us
                          </a>
                        )}
                      </li>
                      <li>
                        <Link
                          to={"privacy-policy"}
                          className="text-sm sm:text-base"
                        // rel="noreferrer"
                        >
                          Privacy Policy
                        </Link>
                      </li>
                      <li>
                        {/* <Link
                          target="_blank"
                          to={"tearm_and_condition"}
                          className="text-sm sm:text-base"
                        >
                          T&C
                        </Link> */}
                        <Link
                          to={"term_and_condition"}
                          className="text-sm sm:text-base"
                        // rel="noreferrer"
                        >
                          T&C
                        </Link>
                      </li>
                    </ul>
                  </div>
                </div>
                <div className="grid-items flex sm:justify-end">
                  <div>
                    <h2 className="font-bold mb-3 text-sm sm:text-base">
                      CONNECT WITH US
                    </h2>
                    <div className="footer-sociallink text-left space-x-2">
                      <a href="https://www.instagram.com/fifomatchapp/">
                        <i className="fa-brands fa-instagram border p-2 h-8 w-8 md:h-9 md:w-9 flex items-center justify-center text-center"></i>
                      </a>
                      <a href="https://www.linkedin.com/company/fifo-match/">
                        <i className="fa-brands fa-linkedin border p-2 h-8 w-8 md:h-9 md:w-9 flex items-center justify-center text-center"></i>
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="copyright text-center py-4 px-3">
          <p className="text-sm sm:text-base mb-0">
            © Copyright 2022 - Fifomatch All Rights Reserved.
          </p>
          <p>ABN 91 759 397 034</p>
        </div>
      </footer>
    </>
  );
};

export default Footer;
