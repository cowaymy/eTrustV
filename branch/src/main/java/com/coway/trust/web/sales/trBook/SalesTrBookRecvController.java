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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.trBook.SalesTrBookRecvService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
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
		String trnsitTo = sessionVO.getCode();

		if(CommonUtils.isEmpty(params.get("pgm"))){

			if ("".equals(trnsitTo) || null == trnsitTo) {
				trnsitTo = "HQ";
			}
			params.put("trnsitTo", trnsitTo);


		//params.put("trnsitTo", sessionVO.getCode());
		//params.put("trnsitTo", "HQ");
		}

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
		List<EgovMap> pendingList = salesTrBookRecvService.selectTransitList(params);
		if ( pendingList != null)
			pendingCnt = pendingList.size();

		params.put("trTrnsitResultStusId", "50");
		List<EgovMap> notRecvList = salesTrBookRecvService.selectTransitList(params);
		if ( notRecvList != null)
			notRecvCnt = notRecvList.size();


		infoList.addAll(recvList);
		infoList.addAll(pendingList);
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

		List<EgovMap> resultList = new ArrayList<EgovMap>();

		if("All".equals(searchType)){
			resultList = salesTrBookRecvService.selectTransitList(params);

		}else if("Recv".equals(searchType)){

			params.put("trTrnsitResultStusId", "4");
			resultList = salesTrBookRecvService.selectTransitList(params);

		}else if("NotRecv".equals(searchType)){
			params.put("trTrnsitResultStusId", "50");
			resultList = salesTrBookRecvService.selectTransitList(params);

		}else if("Pen".equals(searchType)){
			params.put("trTrnsitResultStusId", "44");
			resultList = salesTrBookRecvService.selectTransitList(params);
		}

		return ResponseEntity.ok(resultList);
	}


	@RequestMapping(value = "/updateRecvPop.do")
	public String updateRecvPop(@RequestParam Map<String, Object>params, ModelMap model){

		logger.debug("params ======================================>>> " + params);

		/*int pendingCnt = 0;
		int recvCnt = 0;
		int notRecvCnt = 0;

		EgovMap info = salesTrBookRecvService.selectTransitInfo(params);
		List<EgovMap> infoList = new ArrayList<EgovMap>();

		params.put("trTrnsitResultStusId", "4");
		List<EgovMap> recvList = salesTrBookRecvService.selectTransitList(params);
		if ( recvList != null)
			recvCnt = recvList.size();

		params.put("trTrnsitResultStusId", "44");
		List<EgovMap> pendingList = salesTrBookRecvService.selectTransitList(params);
		if ( pendingList != null) {
			pendingCnt = pendingList.size();
		}

		params.put("trTrnsitResultStusId", "50");
		List<EgovMap> notRecvList = salesTrBookRecvService.selectTransitList(params);
		if ( notRecvList != null)
			notRecvCnt = notRecvList.size();


		infoList.addAll(recvList);
		infoList.addAll(pendingList);
		infoList.addAll(notRecvList);

		info.put("recvCnt", recvCnt);
		info.put("pendingCnt", pendingCnt);
		info.put("notRecvCnt", notRecvCnt);
*/
		model.addAttribute("trnsitId", params.get("trnsitId"));
		/*model.addAttribute("info", info);
		model.addAttribute("pendingList", new Gson().toJson(pendingList));
		model.addAttribute("infoList", new Gson().toJson(infoList));*/

		return "sales/trBookRecv/updateRecvPop";
	}

	@RequestMapping(value = "/selectRecvInfo" , method = RequestMethod.GET)
	public ResponseEntity <EgovMap> selectRecvInfo(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

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
		List<EgovMap> pendingList = salesTrBookRecvService.selectTransitList(params);
		if ( pendingList != null) {
			pendingCnt = pendingList.size();
		}

		params.put("trTrnsitResultStusId", "50");
		List<EgovMap> notRecvList = salesTrBookRecvService.selectTransitList(params);
		if ( notRecvList != null)
			notRecvCnt = notRecvList.size();


		infoList.addAll(recvList);
		infoList.addAll(pendingList);
		infoList.addAll(notRecvList);

		info.put("recvCnt", recvCnt);
		info.put("pendingCnt", pendingCnt);
		info.put("notRecvCnt", notRecvCnt);

/*		model.addAttribute("trnsitId", params.get("trnsitId"));
		model.addAttribute("info", info);
		model.addAttribute("pendingList", new Gson().toJson(pendingList));
		model.addAttribute("infoList", new Gson().toJson(infoList));*/

		/*EgovMap result = new EgovMap();

		result.put("info", info);
		result.put("pendingList", pendingList);
		result.put("infoList", infoList);*/

		info.put("pendingList", pendingList);

		return ResponseEntity.ok(info);
	}

	@RequestMapping(value = "/updateTransit", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateTransit (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		logger.debug("in  saveNewTrBook ");

		logger.debug("params =====================================>>  " + params);
		params.put("userId", sessionVO.getUserId());
		params.put("branchCode", sessionVO.getCode());

		salesTrBookRecvService.updateTransit(params);


		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData("");
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/trBookSummaryPop.do")
	public String trBookSummaryPop(@RequestParam Map<String, Object> params) throws Exception{

		logger.info("################################################## [ Tr Book Summary Pop(Report) Start ]");
		return "sales/trBookRecv/trBookSummaryPop";
	}


	@RequestMapping(value = "/getbrnchList")
	public ResponseEntity<List<EgovMap>> getbrnchList() throws Exception{
		List<EgovMap> brnchList = null;
		brnchList = salesTrBookRecvService.getbrnchList();

		return ResponseEntity.ok(brnchList);
	}


	@RequestMapping(value = "/getTransitListByTransitNo")
	public ResponseEntity<List<EgovMap>> getTransitListByTransitNo(@RequestParam Map<String, Object> params) throws Exception{
		List<EgovMap> transitList = null;
		transitList = salesTrBookRecvService.getTransitListByTransitNo(params);
		return ResponseEntity.ok(transitList);
	}


	@RequestMapping(value = "/trBookSummaryListing")
	public ResponseEntity<List<EgovMap>> trBookSummaryListing(@RequestParam Map<String, Object> params) throws Exception{
		List<EgovMap> trBookSumList = null;
		trBookSumList = salesTrBookRecvService.trBookSummaryListing(params);
		return ResponseEntity.ok(trBookSumList);
	}
}
