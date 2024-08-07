package com.coway.trust.web.sales.pos;

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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.biz.sales.pos.PosOthService;
import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/sales/pos")
public class PosOthController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PosOthController.class);
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@Resource(name = "posOthService")
	private PosOthService posOthService;
	
	@Resource(name = "posService")
	private PosService posService;
	
	
	@RequestMapping(value = "/selectPosOthList.do")
	public String selectPosOthList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		
		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		
		
		return "sales/pos/posOthIncomeList";
	}
	
	
	@RequestMapping(value = "/posSystemOthPop.do")
	public String posSystemPop(@RequestParam Map<String, Object> params,  ModelMap model) throws Exception{
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		   
		params.put("userId", sessionVO.getUserId());
		
		EgovMap memCodeMap = null;
		EgovMap locMap = null;
		memCodeMap = posService.getMemCode(params); //get Brncn ID
		
		if(memCodeMap != null){
			
			if(memCodeMap.get("brnch") != null){ //BRNCH
				params.put("brnchId", memCodeMap.get("brnch"));
				locMap = posService.selectWarehouse(params);
			}
			
		}
		
		model.addAttribute("memCodeMap", memCodeMap);
		model.addAttribute("locMap", locMap);
		
		
		return "sales/pos/posSystemOthPop";
	}
	
	
	@RequestMapping(value = "/selectPOthItmTypeList")
	public ResponseEntity<List<EgovMap>> selectPOthItmTypeList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> othTypeList = null;
		othTypeList = posOthService.selectPOthItmTypeList();
		
		return ResponseEntity.ok(othTypeList);
	}
	
	
/*	@RequestMapping(value = "/selectPOthItmList")
	public ResponseEntity<List<EgovMap>> selectPOthItmList (@RequestParam Map<String, Object> params , HttpServletRequest request) throws Exception{
		
		List<EgovMap>  othItmList = null;
		String itmIdArray [] = request.getParameterValues("itmLists"); 
		params.put("itmIdArray", itmIdArray);
		othItmList = posOthService.selectPOthItmList(params);
		
		return ResponseEntity.ok(othItmList);
		
	}*/
	
	
	@RequestMapping(value= "/chkAllowSalesKeyInPrc")
	public ResponseEntity<Boolean> chkAllowSalesKeyInPrc(@RequestParam Map<String, Object> params) throws Exception{
		
		boolean  rtnVal = false;
		
		rtnVal = posOthService.chkAllowSalesKeyInPrc(params);
		
		return ResponseEntity.ok(rtnVal);
		
	}
	
	
	@RequestMapping(value = "/posReversalOthPop.do")
	public String posReversalOthPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		//posId
		LOGGER.info("######################################### posID : " + params.get("posId"));
		EgovMap revDetailMap = null;
		revDetailMap = posOthService.posReversalOthDetail(params);
		
		model.addAttribute("revDetailMap", revDetailMap);
		return "sales/pos/posReversalOthPop";
		
	}
	
	
	@RequestMapping(value = "/getAddressDetails")
	public ResponseEntity<EgovMap> getAddressDetails(@RequestParam Map<String, Object> params) throws Exception{
		
		EgovMap addrMap = null;
		
		addrMap = posOthService.getAddressDetails(params);
		
		return ResponseEntity.ok(addrMap);
		
	}
}
