package com.coway.trust.web.sales.ccp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.ccp.CcpCTOSB2BService;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp")
public class CcpCTOSB2BController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpCTOSB2BController.class);
	
	@Resource(name = "ccpCTOSB2BService")
	private CcpCTOSB2BService ccpCTOSB2BService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	
	@RequestMapping(value = "/selectB2BList.do")
	public String selectB2BList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		LOGGER.info("################ Start B2BList #########");
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		
		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		
		return "sales/ccp/ccpCTOSB2BList";
		
	}
	
	
	@RequestMapping(value = "/selectCTOSB2BList")
	public ResponseEntity<List<EgovMap>> selectCTOSB2BList(@RequestParam Map<String, Object> params , HttpServletRequest request) throws Exception{
		
		
		LOGGER.info("######################  get CTOS List ###################");
		List<EgovMap> ctosList = null;
		String stusArr[] = request.getParameterValues("stus");
		params.put("stusArr", stusArr);
		ctosList = ccpCTOSB2BService.selectCTOSB2BList(params);
		
		return ResponseEntity.ok(ctosList);
	}
	
	
	@RequestMapping(value = "/getCTOSDetailList")
	public ResponseEntity<List<EgovMap>> getCTOSDetailList (@RequestParam Map<String, Object> params) throws Exception{
		
		LOGGER.info("######################  get CTOS Detail List ###################");
		List<EgovMap> detailList = null;
		detailList = ccpCTOSB2BService.getCTOSDetailList(params);
		
		return ResponseEntity.ok(detailList);
		
	}
	
	
	@RequestMapping(value = "/getCTOSDetailByOrdNo")
	public ResponseEntity<List<EgovMap>> getCTOSDetailByOrdNo (@RequestParam Map<String, Object> params) throws Exception{
		
		LOGGER.info("######################  get CTOS Detail List ###################");
		List<EgovMap> detailList = null;
		detailList = ccpCTOSB2BService.getCTOSDetailList(params);
		
		return ResponseEntity.ok(detailList);
		
	}
	
	@RequestMapping(value = "/getResultRowForCTOSDisplay")
	public ResponseEntity<Map<String, Object>> getResultRowForCTOSDisplay(@RequestParam Map<String, Object> params) throws Exception{
		
		LOGGER.info("####################ResultRow Chk################");
		
		 Map<String, Object> rtnMap =	ccpCTOSB2BService.getResultRowForCTOSDisplay(params);
		 
		LOGGER.info("####################ResultRow Chk RESULT : " + rtnMap.toString());
		return ResponseEntity.ok(rtnMap);
	}
}
