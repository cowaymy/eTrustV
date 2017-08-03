package com.coway.trust.web.sales.order;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderRegisterController {

	private static Logger logger = LoggerFactory.getLogger(OrderRegisterController.class);
	
	@Resource(name = "orderRegisterService")
	private OrderRegisterService orderRegisterService;
	
	@Resource(name = "customerService")
	private CustomerService customerService;
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value = "/orderRegister.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/orderRegister";
	}
	
    @RequestMapping(value = "/selectCustAddJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectCustAddInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
    
    	logger.debug("!@##############################################################################");
    	logger.debug("!@###### custAddId : "+params.get("custAddId"));
    	logger.debug("!@##############################################################################");
    	
    //	EgovMap custAddInfo = orderRegisterService.selectCustAddInfo(params);
    	EgovMap custAddInfo = customerService.selectCustomerViewMainAddress(params);
    
    	if(custAddInfo != null) {
    		if(CommonUtils.isNotEmpty(custAddInfo.get("postCode"))) {
    			params.put("postCode", custAddInfo.get("postCode"));
    			
    			EgovMap brnchInfo = commonService.selectBrnchIdByPostCode(params);
    			
    			custAddInfo.put("brnchId", brnchInfo.get("brnchId"));
    		}
    	}
    	
    	// 데이터 리턴.
    	return ResponseEntity.ok(custAddInfo);
    }
    
    @RequestMapping(value = "/selectCustCntcJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectCustCntcInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
    
        logger.debug("!@##############################################################################");
        logger.debug("!@###### custAddId : "+params.get("custAddId"));
        logger.debug("!@##############################################################################");
        
        EgovMap custAddInfo = customerService.selectCustomerViewMainContact(params);
    
        // 데이터 리턴.
        return ResponseEntity.ok(custAddInfo);
    }

    @RequestMapping(value = "/selectSrvCntcJsonInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> selectSrvCntcInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
    
        logger.debug("!@##############################################################################");
        logger.debug("!@###### /selectSrvCntcJsonInfo.do : custCareCntId : "+params.get("custCareCntId"));
        logger.debug("!@##############################################################################");
        
        EgovMap custAddInfo = orderRegisterService.selectSrvCntcInfo(params);
    
        // 데이터 리턴.
        return ResponseEntity.ok(custAddInfo);
    }
    
}
