/**
 * 
 */
package com.coway.trust.web.sales.mambership;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.mambership.MembershipConvSaleService;



/**
 * 
 * @author hamhg
 *
 */
@Controller
@RequestMapping(value = "/sales/membership")
public class  MembershipConvSaleController {

	private static Logger logger = LoggerFactory.getLogger(MembershipConvSaleController.class);
	
	@Resource(name = "membershipConvSaleService")
	private MembershipConvSaleService membershipConvSaleService;        
	
	@RequestMapping(value = "/mConvSale.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  mConvSale.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		return "sales/membership/mQuotConvSalePop";  
	}
	
		

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	
}
