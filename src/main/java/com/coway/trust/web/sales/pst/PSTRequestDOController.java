/**
 * 
 */
package com.coway.trust.web.sales.pst;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.coway.trust.biz.sales.pst.PSTRequestDOService;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/pst")
public class PSTRequestDOController {

	private static final Logger logger = LoggerFactory.getLogger(PSTRequestDOController.class);
	
	@Resource(name = "pstRequestDOService")
	private PSTRequestDOService pstRequestDOService;
	
}
