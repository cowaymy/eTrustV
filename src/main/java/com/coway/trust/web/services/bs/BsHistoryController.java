package com.coway.trust.web.services.bs;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.services.bs.BsHistoryService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value ="/services/bs")
public class BsHistoryController {
	private static final Logger logger = LoggerFactory.getLogger(BsHistoryController.class);
	
	@Resource(name = "bsHistoryService")
	private BsHistoryService bsHistoryService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	/**
	 * organization transfer page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/bsHistory.do")
	public String bsHistory(@RequestParam Map<String, Object> params, ModelMap model) {
		
		return "services/bs/bsHistory";
	}
	
	@RequestMapping(value = "/bsHistorySearch", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> bsHistorySearch(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> orderList = bsHistoryService.selectOrderList(params);
		for(int i=0;i<orderList.size();i++){
			int filter = bsHistoryService.selectFilterCnt(orderList.get(i));
			if(filter>0){
				orderList.get(i).put("hasFilter", 'O');
			}else{
				orderList.get(i).put("hasFilter", 'X');
			}
		}
		
		
		
		return ResponseEntity.ok(orderList);
	}		
	
	@RequestMapping(value = "/bsHistorySearch2", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> bsHistorySearch2(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> orderList = bsHistoryService.selectOrderList(params);
		for(int i=0;i<orderList.size();i++){
			int filter = bsHistoryService.selectFilterCnt(orderList.get(i));
			if(filter>0){
				orderList.get(i).put("hasFilter", 'O');
			}else{
				orderList.get(i).put("hasFilter", 'X');
			}
		}
		
		
		
		return ResponseEntity.ok(orderList.get(0));
	}
	
	
	@RequestMapping(value = "/filterInfoPop2.do")
	public String filterInfoPop2(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("orderId", params.get("orderId"));
		return "services/bs/bsFilterInfoPop";
	}
	/*
	@RequestMapping(value = "/filterInfoPop.do")
	public String filterInfoPop(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> filterInfo = bsHistoryService.filterInfo(params);
		logger.debug("params : {}",params);
		logger.debug("installStatus : {}",filterInfo);
		model.addAttribute("filterInfo", filterInfo);
		return "services/bs/bsFilterInfoPop";
	}
	*/
	
	@RequestMapping(value = "/filterInfoPop", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> filterInfoPop(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> filterInfo = bsHistoryService.filterInfo(params);
		return ResponseEntity.ok(filterInfo);
	}
	
	@RequestMapping(value = "/filterTreePop2.do")
	public String filterTreePop2(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("orderId", params.get("orderId"));
		model.addAttribute("bsrId", params.get("bsrId"));
		return "services/bs/bsFilterTreePop";
	}
	
	@RequestMapping(value = "/filterTreePop", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> filterTreePop(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("params : {}",params);
		List<EgovMap> filterTree = bsHistoryService.filterTree(params);
		
		return ResponseEntity.ok(filterTree);
	}
}
