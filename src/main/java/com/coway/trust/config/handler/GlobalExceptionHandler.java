package com.coway.trust.config.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.AuthException;
import com.coway.trust.cmmn.model.ReturnMessage;

/**
 * 
 * @author lim
 *
 */
@EnableWebMvc
@ControllerAdvice
public class GlobalExceptionHandler {
	private static final Logger LOGGER = LoggerFactory.getLogger(GlobalExceptionHandler.class);

	@ExceptionHandler(NoHandlerFoundException.class)
	public Object handleError404(HttpServletRequest request, HttpServletResponse response, NoHandlerFoundException ex) {
		LOGGER.error("[handleError404]message : {}", ex.getMessage());
		LOGGER.error("[handleError404]ex : {}", ex);
		LOGGER.debug("request : {}", request.getRequestURI());

		String contentType = request.getHeader(HttpHeaders.CONTENT_TYPE);
		if (isRest(request.getRequestURI(), contentType)) {
			ReturnMessage message = new ReturnMessage();
			message.setCode(String.valueOf(HttpStatus.NOT_FOUND.value()));
			message.setMessage("Resource not found for HTTP request with URI");
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);
			return new ResponseEntity<Object>(message, headers, HttpStatus.NOT_FOUND);
		} else {
			ModelAndView mav = new ModelAndView("error/error");
			mav.addObject("exception", ex);
			return mav;
		}
	}

	@ExceptionHandler(ApplicationException.class)
	public Object applicationException(HttpServletRequest request, HttpServletResponse response,
			ApplicationException ex) {
		LOGGER.error("[applicationException]code : {}", ex.getCode());
		LOGGER.error("[applicationException]message : {}", ex.getMessage());
		LOGGER.error("[applicationException]ex : {}", ex);
		String contentType = request.getHeader(HttpHeaders.CONTENT_TYPE);
		if (isRest(request.getRequestURI(), contentType)) {
			ReturnMessage message = new ReturnMessage();
			message.setCode(ex.getCode());
			message.setMessage(ex.getMessage());
			message.setDetailMessage(ex.getDetailMessage());
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);
			return new ResponseEntity<Object>(message, headers, HttpStatus.INTERNAL_SERVER_ERROR);
		} else {
			ModelAndView mav = new ModelAndView("error/error");
			mav.addObject("exception", ex);
			return mav;
		}
	}

	@ExceptionHandler(AuthException.class)
	public Object authException(HttpServletRequest request, HttpServletResponse response, AuthException ex) {
		LOGGER.error("[authException]message : {}", ex.getMessage());
		LOGGER.error("[authException]ex : {}", ex);
		String contentType = request.getHeader(HttpHeaders.CONTENT_TYPE);

		if (isRest(request.getRequestURI(), contentType)) {
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.FAIL);
			message.setMessage("Exception : " + ex.getMessage());
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);
			return new ResponseEntity<Object>(message, headers, ex.getHttpStatus());
		} else {
			String redirect = AppConstants.REDIRECT_LOGIN;
			HttpStatus httpStatus = ex.getHttpStatus();
			if (HttpStatus.FORBIDDEN == httpStatus) {
				redirect = AppConstants.REDIRECT_UNAUTHORIZED;
			}
			ModelAndView mav = new ModelAndView(redirect);
			mav.addObject("exception", ex.getHttpStatus());
			return mav;
		}
	}

	@ExceptionHandler(Exception.class)
	public Object defaultException(HttpServletRequest request, HttpServletResponse response, Exception ex) {
		LOGGER.error("[defaultException]message : {}", ex.getMessage());
		LOGGER.error("[defaultException]ex : {}", ex);
		String contentType = request.getHeader(HttpHeaders.CONTENT_TYPE);

		if (isRest(request.getRequestURI(), contentType)) {
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.FAIL);
			message.setMessage("Exception : " + ex.getMessage());
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);
			return new ResponseEntity<Object>(message, headers, HttpStatus.INTERNAL_SERVER_ERROR);
		} else {
			ModelAndView mav = new ModelAndView("error/error");
			mav.addObject("exception", ex);
			return mav;
		}
	}

	private boolean isRest(String uri, String contentType) {
		if (uri.contains(AppConstants.API_BASE_URI)) {
			return true;
		}

		if (contentType.startsWith(MediaType.APPLICATION_JSON_VALUE)
				|| contentType.startsWith(MediaType.MULTIPART_FORM_DATA_VALUE)) {
			return true;
		}
		return false;
	}
}
