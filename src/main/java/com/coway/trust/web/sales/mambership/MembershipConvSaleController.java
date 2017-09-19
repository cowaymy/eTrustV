/**
 * 
 */
package com.coway.trust.web.sales.mambership;

import java.util.List;
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
import com.coway.trust.biz.sales.mambership.MembershipService;
import com.coway.trust.biz.sales.mambership.impl.MembershipMapper;

import egovframework.rte.psl.dataaccess.util.EgovMap;



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

	@Resource(name = "membershipService")
	private MembershipService membershipService;
	
	
	@RequestMapping(value = "/mConvSale.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  mConvSale.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		model.addAttribute("ORD_ID",params.get("ORD_ID"));
		
		return "sales/membership/mQuotConvSalePop";  
	}
	
	
	
	@RequestMapping(value = "/mAutoConvSale.do")
	public String mAutoConvSale(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  mAutoConvSale.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString()); 
		logger.debug("			pram set end  ");
		  
		List<EgovMap> list = membershipService.selectMembershipQuotInfo(params);

		
		logger.debug("===>"+list.toString());
		
		model.addAttribute("ORD_ID",((EgovMap)list.get(0)).get("ordId"));
		model.addAttribute("QUOT_ID",params.get("QUOT_ID"));
		logger.debug("=ordId==>"+((EgovMap)list.get(0)).get("ordId"));
		logger.debug("QUOT_ID {}",params.get("QUOT_ID"));
		
		return "sales/membership/mQuotConvSalePop";   
	}
	
		

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	
}
