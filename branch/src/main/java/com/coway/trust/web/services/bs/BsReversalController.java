package com.coway.trust.web.services.bs;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import com.coway.trust.biz.services.bs.BsReversalService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/bs")
public class BsReversalController {
	private static final Logger logger = LoggerFactory.getLogger(BsReversalController.class);
	
	@Resource(name = "bsReversalService")
	private BsReversalService bsReversalService;
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
	@RequestMapping(value = "/bsReversal.do")
	public String hsResultList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> selectReverseReason = bsReversalService.selectReverseReason();
		List<EgovMap> selectFailReason = bsReversalService.selectFailReason();
		
		
		
		model.addAttribute("selectReverseReason", selectReverseReason);
		model.addAttribute("selectFailReason", selectFailReason);
		
		return "services/bs/bsReversal";
	}
	
	/**
	 * Search hs reversal orderNo
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/bsReversalSearch", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> bsReversalListSearch(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {


		List<EgovMap> orderList = bsReversalService.selectOrderList(params);
		return ResponseEntity.ok(orderList);
	}
	
	
	
	@RequestMapping(value = "/bsReversalSearchDetail" ,method = RequestMethod.POST)
	public ResponseEntity<Map>  bsReversalSearchDetail(@RequestBody Map<String, Object> params, Model model)	throws Exception {
		
		params.put("orderNo", params.get("salesOrdId"));
		EgovMap configBasicInfo = bsReversalService.selectConfigBasicInfo(params);
		
		Map<String, Object> map = new HashMap();
		map.put("list1", configBasicInfo);
		
		return ResponseEntity.ok(map);
	}
	
}
	


