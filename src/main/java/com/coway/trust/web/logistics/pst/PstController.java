package com.coway.trust.web.logistics.pst;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.coway.trust.config.handler.SessionHandler;

@Controller
@RequestMapping(value = "/logistics/pst")
public class PstController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/pst.do")
	public String stockTransferDeliveryList(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/pst/pst";
	}

}
