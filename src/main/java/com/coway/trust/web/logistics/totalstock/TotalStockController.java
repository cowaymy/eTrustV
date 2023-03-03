package com.coway.trust.web.logistics.totalstock;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.logistics.totalstock.TotalStockService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/totalstock")
public class TotalStockController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "TotalStockService")
	private TotalStockService TotalStockService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/TotalStock.do")
	public String totalstock(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/TotalStock/totalStockList";
	}

	@RequestMapping(value = "/SearchSessionInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map> SearchSessionInfo(@RequestParam Map<String, Object> params, Model model)
			throws Exception {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String  UserName;
		String  UserCode;
		int BranchId = sessionVO.getUserBranchId();

		if (sessionVO == null) {
			UserName = "ham";
		} else {
			UserName = sessionVO.getUserName();
		}
		if (sessionVO == null) {
			UserCode = "T010";
		} else {
			UserCode = "T010";
			//UserCode = sessionVO.getCode();
		}

//		logger.debug("UserName    값 : {}", UserName);
//		logger.debug("UserCode    값 : {}", UserCode);
//		logger.debug("branch_id 값 : ", BranchId);

		Map<String, Object> map = new HashMap();
		map.put("UserName", UserName);
		map.put("UserCode", UserCode);

		return ResponseEntity.ok(map);
	}



//	@RequestMapping(value = "/totStockSearchList.do", method = RequestMethod.POST)
//	public ResponseEntity<Map> totStockSearchList(@RequestBody Map<String, Object> params, Model model, HttpServletRequest request,
//			HttpServletResponse response)
//			throws Exception {

	@RequestMapping(value = "/totStockSearchList.do", method = RequestMethod.GET)
		public ResponseEntity<Map> PosItemList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		String searchMatCode = request.getParameter("searchMatCode");
		String[] searchType = request.getParameterValues("searchType");
		String[] searchCtgry = request.getParameterValues("searchCtgry");
		String[] searchlocgb = request.getParameterValues("searchlocgb");
		String[] searchLoc = request.getParameterValues("searchLoc");
		String searchlocgrade = request.getParameter("searchlocgrade");
		String searchBranch = request.getParameter("searchBranch");
		String searchCDC = request.getParameter("searchCDC");

		String sstocknm = request.getParameter("searchMatName");

		Map<String, Object> smap = new HashMap();

		smap.put("searchMatCode", searchMatCode);
		smap.put("searchLoc", searchLoc);
		smap.put("searchType", searchType);
		smap.put("searchCtgry", searchCtgry);
		smap.put("searchlocgb", searchlocgb);
		smap.put("searchlocgrade", searchlocgrade);
		smap.put("sstocknm", sstocknm);
		smap.put("searchBranch", searchBranch);
		smap.put("searchCDC", searchCDC);


		List<EgovMap> list = TotalStockService.totStockSearchList(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectTotalBranchList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selecttotalBranchList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = TotalStockService.selectBranchList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectCDCList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCDCList(@RequestParam Map<String, Object> params) {

		//logger.debug("searchBranch@@@@@: {}", params.get("searchBranch"));

		List<EgovMap> codeList = TotalStockService.selectCDCList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/totalStockPdfPop.do")
	public String totalStockPdfPop(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/TotalStock/totalStockPdfPop";
	}

	@RequestMapping(value = "/totalStockCtPop.do")
	public String totalStockCtPop(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/TotalStock/totalStockCtPop";
	}

	@RequestMapping(value = "/selectTotalDscList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTotalDscList(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = TotalStockService.selectTotalDscList(params);
		return ResponseEntity.ok(codeList);
	}

}
