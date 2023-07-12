import React, { useState, useEffect } from "react";
import Header from "./Header";
import Footer from "./Footer";
import Slider from "react-slick";
import { useForm } from "react-hook-form";
import axios from "axios";
import { toast } from "react-toastify";
import { useLocation, Link } from "react-router-dom";

import "react-toastify/dist/ReactToastify.css";

const Root = () => {
  const location = useLocation();
  const [img, setImg] = useState("");
  var settings = {
    dots: true,
    infinite: true,
    speed: 500,
    // centerMode: true,
    slidesToShow: 5,
    slidesToScroll: 1,
    responsive: [
      {
        breakpoint: 1240,
        settings: {
          slidesToShow: 5,
          dots: true,
        },
      },
      {
        breakpoint: 1025,
        settings: {
          slidesToShow: 3,
        },
      },
      {
        breakpoint: 992,
        settings: {
          slidesToShow: 3,
        },
      },

      {
        breakpoint: 576,
        settings: {
          slidesToShow: 1,
        },
      },
    ],
  };

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
        `${process.env.REACT_APP_API_BASE_URL}contact_form_submit`,
        data
      );
      toast.success("Form successfully submitted", {
        position: "top-right",
        autoClose: 5000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        progress: undefined,
      });
      e.target.reset();
      /* if (response?.status === 200) {
        toast.success("Form successfully submitted", {
          position: "top-right",
          autoClose: 5000,
          hideProgressBar: false,
          closeOnClick: true,
          pauseOnHover: true,
          draggable: true,
          progress: undefined,
        });
        e.target.reset();
      } */
    } catch (error) {
      toast.success("Form successfully submitted", {
        position: "top-right",
        autoClose: 5000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        progress: undefined,
      });
      e.target.reset();
      console.log(error.message);
    }
  };

  // useEffect(()=>{
  //   setImg('assets/images/banner_img.jpg')
  // })

  return (
    <>
      <div className="App">
        <div className="banner relative" id="home">
          <div>
            <img src="assets/images/banner_img.jpg" className="w-full" alt="" />
            {/* <div className="w-full h-full top-0 bottom-0 left-0 right-0 absolute bg-black/[.2] -z-10 "></div> */}
          </div>
          <div className="caption absolute w-full">
            <div className="container mx-auto flex sm:justify-end">
              <div className="w-full text-center sm:text-left sm:text-left welcome_info">
                <h3 className="text-gray-800 md:text-1xl xl:text-2xl text-lg hidden sm:block">
                  WELCOME TO
                </h3>
                <h1 className="text-orange-500 sm:text-3xl text-2xl md:text-5xl lg:text-[70px] fifo-heading mt-2">
                  FIFO Match
                  <span className="block sm:text-[18px] lg:text-[24px] text-[16px] mt-3 md:mt-5 lg:leading-8 leading-5">
                    The simple way to connect with others who understand your
                    work roster.
                  </span>
                </h1>
                <p className="text-white sm:text-gray-800 text-base banner-caption-text mt-4">
                  FIFO Match, established by FIFO Workers for FIFO Workers who
                  understand the lifestyle. Regardless of where you’re flying in
                  from, you’ll find a suitable match.
                </p>

                <div className="app_icon mt-3 sm:mt-4">
                  <h6 className="text-white sm:text-gray-800 text-base">
                    App coming soon.{" "}
                    {/* <a href="#contactus" style={{ color: "#FF6C0A" }}>
                      Register your interest here
                    </a> */}
                    {location.pathname.includes("/term_and_condition") ||
                      location.pathname.includes("/privacy-policy") ? (
                      <Link
                        to="/"
                        state={{ from: "register" }}
                        style={{ color: "#FF6C0A" }}
                      >
                        Register your interest here
                      </Link>
                    ) : (
                      <a href="/#register" style={{ color: "#FF6C0A" }}>
                        Register your interest here
                      </a>
                    )}
                  </h6>
                  <div className="app-link flex items-center mt-2 lg:mt-3">
                    <a href="/#register">
                      <img src="assets/images/play_store.jpg" alt="" />
                    </a>
                    <a
                      className="ml-2 sm:ml-6"
                      href="/#register"
                    // target={"_blank"}
                    // rel="noreferrer"
                    >
                      <img src="assets/images/app_store.jpg" alt="" />
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* <img src="assets/images/form_bg.jpg" className="w-full" alt=""/> */}

        <section
          className="app-feature bg-gray py-5 md:py-8 lg:py-12 bg-white-50 relative"
          id={"about-section"}
        >
          <div className="container mx-auto">
            <h2 className="section-title text-orange-500 font-bold text-center text-2xl md:text-3xl lg:text-4xl mb-5 ">
              About Us
            </h2>
            <p className="text-[14px] text-center">
              FIFO MATCH was established in 2022, a dating app aimed at
              individuals who are FIFO workers or anyone working away from home
              with a complicated roster, finding it hard to meet people. FIFO
              MATCH makes it easy for people with a unique work-life balance to
              meet others who understand. You don’t have to explain to them that
              you’re always away and your roster is constantly changing, you
              don’t have to explain to them that you’re not always going to be
              around. Both parties understand the complexities and are open and
              willing to connect and even match. Enter FIFO Match.
            </p>
            <div className="showcase-slider-outer relative">
              <span className="mobile-fream absolute text-center">
                <img
                  src="./assets/images/mobilefream.png"
                  className="mx-auto"
                />
              </span>
              <div className="slider showcase-slider">
                <Slider {...settings}>
                  <div className="showcase-item">
                    <img
                      src="./assets/images/showcase-slider1.png"
                      className="mx-auto"
                    />
                  </div>

                  <div className="showcase-item">
                    <img
                      src="./assets/images/showcase-slider2.png"
                      className="mx-auto"
                    />
                  </div>
                  <div className="showcase-item">
                    <img
                      src="./assets/images/showcase-slider3.png"
                      className="mx-auto"
                    />
                  </div>

                  <div className="showcase-item">
                    <img
                      src="./assets/images/showcase-slider4.png"
                      className="mx-auto"
                    />
                  </div>

                  <div className="showcase-item">
                    <img
                      src="./assets/images/showcase-slider5.png"
                      className="mx-auto"
                    />
                  </div>

                  <div className="showcase-item">
                    <img
                      src="./assets/images/showcase-slider1.png"
                      className="mx-auto"
                    />
                  </div>

                  <div className="showcase-item">
                    <img
                      src="./assets/images/showcase-slider2.png"
                      className="mx-auto"
                    />
                  </div>
                </Slider>
              </div>
            </div>
          </div>
        </section>

        {/* contact us */}
        <section className="fifo-match" id="register">
          <figure className="relative">
            <img
              src="./assets/images/form_bg.jpg"
              alt=""
              className="w-full mix-blend-overlay"
            />
            <div className="w-full h-full top-0 bottom-0 left-0 right-0 absolute bg-black/[.4] -z-10 "></div>
          </figure>
          <div className="container mx-auto">
            <section className="fifo-sec">
              <div className="h-full text-gray-800">
                <div className="grid grid-cols-1 md:grid-cols-2 shadow-lg items-stretch">
                  <div className="grid-item fifo-back p-10 pb-0 flex items-end relative">
                    <img
                      src="./assets/images/cantact_img.png"
                      className="w-full"
                      alt="Sample image"
                    />
                  </div>
                  <div className="grid-item p-5 md:p-8 dots relative bg-white z-10">
                    <div className="form_head">
                      <h3 align="center">Register Your Interest</h3>
                      <span>
                        Be one of the first to register your interest in joining
                        FIFO Match and receive your first two months free*.
                      </span>
                    </div>
                    <form onSubmit={handleSubmit(onSubmit)}>
                      {/* first name */}
                      <div className="mb-3 text-left">
                        <label
                          htmlFor="exampleFormControlTextarea1"
                          className="form-label inline-block mb-2 text-gray-700 font-semibold"
                        >
                          First Name
                        </label>
                        <input
                          type="text"
                          className="form-control text-base h-10 md:h-14 block w-full px-4 py-2 font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                          id="exampleFormControlTextarea1"
                          placeholder="Enter Name"
                          {...register("name", {
                            required: {
                              value: true,
                              message: "Please enter first name.",
                            },
                            minLength: {
                              value: 2,
                              message:
                                "First name should contain at least 2 characters.",
                            },
                            maxLength: {
                              value: 30,
                              message:
                                "First name should not exceed 30 characters.",
                            },
                            pattern: {
                              value: /^[A-Za-z ]*$/,
                              message: "Please enter valid first name",
                            },
                          })}
                          onChange={(e) =>
                            setValue("name", e.target.value, {
                              shouldValidate: true,
                            })
                          }
                        />
                        {errors?.name?.message && (
                          <p className="text-orange-500">
                            {errors?.name?.message}
                          </p>
                        )}
                      </div>

                      {/* last name */}
                      <div className="mb-3 text-left">
                        <label
                          htmlFor="exampleFormControlTextarea1"
                          className="form-label inline-block mb-2 text-gray-700 font-semibold"
                        >
                          Last Name
                        </label>
                        <input
                          type="text"
                          className="form-control text-base h-10 md:h-14 block w-full px-4 py-2 font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                          id="exampleFormControlTextarea1"
                          placeholder="Enter Last Name"
                          {...register("lname", {
                            required: {
                              value: true,
                              message: "Please enter last name.",
                            },
                            minLength: {
                              value: 2,
                              message:
                                "Last name should contain at least 2 characters.",
                            },
                            maxLength: {
                              value: 30,
                              message:
                                "Last name should not exceed 30 characters.",
                            },
                            pattern: {
                              value: /^[A-Za-z ]*$/,
                              message: "Please enter valid last name",
                            },
                          })}
                          onChange={(e) =>
                            setValue("lname", e.target.value, {
                              shouldValidate: true,
                            })
                          }
                        />
                        {errors?.lname?.message && (
                          <p className="text-orange-500">
                            {errors?.lname?.message}
                          </p>
                        )}
                      </div>

                      {/* email */}
                      <div className="mb-3 text-left">
                        <label
                          htmlFor="exampleFormControlTextarea2"
                          className="form-label inline-block mb-2 text-gray-700 font-semibold"
                        >
                          Email
                        </label>
                        <input
                          type="email"
                          className="form-control block text-base h-10 md:h-14 w-full px-4 py-2 font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                          id="exampleFormControlTextarea2"
                          placeholder="Enter Email"
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
                          <p className="text-orange-500">
                            {errors?.email?.message}
                          </p>
                        )}
                      </div>

                      {/* locations */}
                      <div className="mb-3 text-left">
                        <label
                          htmlFor="exampleFormControlTextarea2"
                          className="form-label inline-block mb-2 text-gray-700 font-semibold inline-block"
                        >
                          Location
                        </label>
                        <select
                          className="form-control text-base h-10 md:h-14 block w-full px-4 py-2 font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                          {...register("location", {
                            required: {
                              value: true,
                              message: "Please select location",
                            },
                          })}
                          onChange={(e) =>
                            setValue("location", e.target.value, {
                              shouldValidate: true,
                            })
                          }
                        >
                          <option value="" name="location">
                            Please select location
                          </option>
                          <option value="Western Australia" name="location">
                            Western Australia
                          </option>
                          <option value="South Australia" name="location">
                            South Australia
                          </option>
                          <option value="Queensland" name="location">
                            Queensland
                          </option>
                          <option value="Northern Territory" name="location">
                            Northern Territory
                          </option>
                          <option value="New South Wales" name="location">
                            New South Wales
                          </option>
                          <option value="Other">Other</option>
                        </select>
                        {errors?.location?.message && (
                          <p className="text-orange-500">
                            {errors?.location?.message}
                          </p>
                        )}
                      </div>

                      {/* mobile number */}
                      <div className="mb-3 text-left">
                        <label
                          htmlFor="exampleFormControlTextarea3"
                          className="form-label inline-block mb-2 text-gray-700 font-semibold"
                        >
                          Contact No.
                        </label>
                        <input
                          type="number"
                          className="form-control text-base h-10 md:h-14 block w-full px-4 py-2 font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                          id="exampleFormControlTextarea3"
                          placeholder="Enter Contact Number"
                          {...register("contact_no", {
                            // required: {
                            //   value: true,
                            //   message: "Please enter phone number",
                            // },
                            minLength: {
                              value: 7,
                              message:
                                "Phone number should contain at least 7 characters.",
                            },
                            maxLength: {
                              value: 15,
                              message:
                                "Phone number should not exceed 15 characters.",
                            },
                            pattern: {
                              value:
                                /^((\\+[1-9]{1,4}[ \\-]*)|(\\([0-9]{2,3}\\)[ \\-]*)|([0-9]{2,4})[ \\-]*)*?[0-9]{3,4}?[ \\-]*[0-9]{3,4}?$/,
                              message: "Please enter valid phone number.",
                            },
                          })}
                          onChange={(e) =>
                            setValue("contact_no", e.target.value, {
                              shouldValidate: true,
                            })
                          }
                        />
                        {errors?.contact_no?.message && (
                          <p className="text-orange-500">
                            {errors?.contact_no?.message}
                          </p>
                        )}
                      </div>

                      {/* message */}
                      <div className="mb-4 text-left">
                        <label
                          htmlFor="exampleFormControlTextarea4"
                          className="form-label inline-block mb-2 text-gray-700 font-semibold"
                        >
                          Message
                        </label>
                        <textarea
                          className="form-control block w-full px-3 py-1.5 text-base font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                          id="exampleFormControlTextarea4"
                          rows="4"
                          placeholder="Your message"
                          {...register("message", {
                            // required: {
                            //   value: true,
                            //   message: "Please enter message.",
                            // },
                            minLength: {
                              value: 10,
                              message:
                                "Message should contain at least 10 characters.",
                            },
                            maxLength: {
                              value: 300,
                              message:
                                "Message should not exceed 300 characters.",
                            },
                          })}
                          onChange={(e) =>
                            setValue("message", e.target.value, {
                              shouldValidate: true,
                            })
                          }
                        ></textarea>
                        {errors?.message?.message && (
                          <p className="text-orange-500">
                            {errors?.message?.message}
                          </p>
                        )}
                      </div>

                      <div className="text-center lg:text-left">
                        <button
                          type="submit"
                          className="bg-transparent  text-orange-500 w-full h-10 md:h-14 hover:bg-orange-500 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded"
                        >
                          SUBMIT
                        </button>
                      </div>
                    </form>
                    <span className="block mt-2">
                      *This offer is valid for a standard account only and valid
                      per applicant.
                    </span>
                  </div>
                </div>
              </div>
            </section>
          </div>
        </section>
      </div>
    </>
  );
};

export default Root;
