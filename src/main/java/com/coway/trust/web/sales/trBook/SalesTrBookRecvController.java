package com.coway.trust.web.sales.trBook;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.trBook.SalesTrBookRecvService;
import com.coway.trust.cmmn.model.SessionVO;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/trBookRecv")
public class SalesTrBookRecvController {

	private static final Logger logger = LoggerFactory.getLogger(SalesTrBookRecvController.class);
	
	@Resource(name = "salesTrBookRecvService")
	private SalesTrBookRecvService salesTrBookRecvService;	
		
	@Autowired
	private MessageSourceAccessor messageAccessor;
	

	@RequestMapping(value = "/trBookRecvMgmt.do")
	public String trBookRecvMgmt(@RequestParam Map<String, Object>params, ModelMap model){
		
		logger.debug("params ======================================>>> " + params);

		return "sales/trBookRecv/trBookRecvMgmt";
	}
	
	@RequestMapping(value = "/selectTrBookRecvList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectTrBookRecvList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		
		logger.debug("params ======================================>>> " + params);
		
		params.put("trnsitTo", sessionVO.getCode());
		 
		List<EgovMap> list = salesTrBookRecvService.selectTrBookRecvList(params);

	
		return ResponseEntity.ok(list);
	}
	

	@RequestMapping(value = "/trBookRecvViewPop.do")
	public String trBookRecvViewPop(@RequestParam Map<String, Object>params, ModelMap model){
		
		logger.debug("params ======================================>>> " + params);
		
		int pendingCnt = 0;
		int recvCnt = 0;
		int notRecvCnt = 0;		
		
		EgovMap info = salesTrBookRecvService.selectTransitInfo(params);
		List<EgovMap> infoList = new ArrayList<EgovMap>();

		params.put("trTrnsitResultStusId", "4");
		List<EgovMap> recvList = salesTrBookRecvService.selectTransitList(params);		 
		if ( recvList != null) 
			recvCnt = recvList.size();	

		params.put("trTrnsitResultStusId", "44");
		List<EgovMap> pendignList = salesTrBookRecvService.selectTransitList(params);		
		if ( pendignList != null) 
			pendingCnt = pendignList.size();

		params.put("trTrnsitResultStusId", "50");
		List<EgovMap> notRecvList = salesTrBookRecvService.selectTransitList(params);
		if ( notRecvList != null) 
			notRecvCnt = notRecvList.size();
		
		
		infoList.addAll(recvList);
		infoList.addAll(pendignList);
		infoList.addAll(notRecvList);
		
		info.put("recvCnt", recvCnt);
		info.put("pendingCnt", pendingCnt);
		info.put("notRecvCnt", notRecvCnt);

		model.addAttribute("trnsitId", params.get("trnsitId"));
		model.addAttribute("info", info);
		model.addAttribute("infoList", new Gson().toJson(infoList));
		
		return "sales/trBookRecv/trBookRecvViewPop";
	}
	
	@RequestMapping(value = "/selectTransitList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectTransitList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		
		logger.debug("params ======================================>>> " + params);
		
		
		String searchType =  params.get("searchType").toString();
		params.put("trnsitId", params.get("trnsitId"));
		
		List<EgovMap> rsultList = new ArrayList<EgovMap>();
		
		if("All".equals(searchType)){
			rsultList = salesTrBookRecvService.selectTransitList(params);

		}else if("Recv".equals(searchType)){

			params.put("trTrnsitResultStusId", "4");
			rsultList = salesTrBookRecvService.selectTransitList(params);
			
		}else if("NotRecv".equals(searchType)){
			params.put("trTrnsitResultStusId", "50");
			rsultList = salesTrBookRecvService.selectTransitList(params);
		}
		
		return ResponseEntity.ok(rsultList);
	}

}
