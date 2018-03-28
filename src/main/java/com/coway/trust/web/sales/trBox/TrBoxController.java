package com.coway.trust.web.sales.trBox;

import java.text.ParseException;
import java.util.ArrayList;
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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.stocks.StockService;
import com.coway.trust.biz.sales.trbox.TrboxService;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/misc/TRBox")
public class TrBoxController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "trboxService")
	private TrboxService trbox;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/TrBoxManagement.do")
	public String trboxmanagementList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "sales/trbox/trboxmanagementList";
	}
	@RequestMapping(value = "/TrBoxReceive.do")
	public String trboxreceiveList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "sales/trbox/trboxreceiveList";
	}
	@RequestMapping(value = "/TrBoxBulkTransfer.do")
	public String TrBoxBulkTransfer(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "sales/trbox/trboxbulkTransfer";
	}

	@RequestMapping(value = "/getSearchTrboxManagementList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> getSearchTrboxManagementList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model)
			throws Exception {

		String trbxnumber = request.getParameter("trbxnumber");
		String sdate      = request.getParameter("sdate");
		String edate      = request.getParameter("edate");
		String crtuser    = request.getParameter("crtuser");

		String[] status   = request.getParameterValues("status");
		String branchid   = request.getParameter("branchid");
		String bulkholder = request.getParameter("bulkholder");
		String boxno      = request.getParameter("boxno");

		Map<String, Object> pmap = new HashMap();
		pmap.put("trbxnumber", trbxnumber);
		pmap.put("sdate"     , sdate     );
		pmap.put("edate"     , edate     );
		pmap.put("crtuser"   , crtuser   );
		pmap.put("status"    , status    );
		pmap.put("branchid"  , branchid  );
		pmap.put("bulkholder", bulkholder);
		pmap.put("boxno"     , boxno);

		logger.debug("91Line :::: {}" , pmap);
		List<EgovMap> list = trbox.selectTrboxManagementList(pmap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/getSelectTrboxManageDetailList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> getSelectTrboxManageDetailList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model)
			throws Exception {

		List<EgovMap> list = trbox.selectTrboxManageDetailList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/postNewTrboxManagementSave.do", method = RequestMethod.POST)
	public ResponseEntity<Map> postNewTrboxManagementSave(@RequestBody Map<String, Object>params, HttpServletRequest request, ModelMap model , SessionVO sessionVo)
			throws Exception {

		logger.debug("107Line :::: {}" , params);
		int userId = sessionVo.getUserId();

		params.put("userid", userId);

		String boxno = trbox.postNewTrboxManagementSave(params);
		Map<String, Object> map = new HashMap();
		map.put("trboxno", boxno);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/getUpdateKeepReleaseRemove.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> getUpdateKeepReleaseRemove(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVo)
			throws Exception {
		int userId = sessionVo.getUserId();
		params.put("userid", userId);
		trbox.getUpdateKeepReleaseRemove(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/getCloseReopn.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> getCloseReopn(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVo)
			throws Exception {
		int userId = sessionVo.getUserId();
		params.put("userid", userId);
		trbox.getCloseReopn(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/getUpdateTrBoxInfo.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> getUpdateTrBoxInfo(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVo)
			throws Exception {
		int userId = sessionVo.getUserId();
		params.put("userid", userId);

		List<EgovMap> list = trbox.selectTrboxManagement(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(list);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectTransferCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTransferCodeList(@RequestParam Map<String, Object> params) throws Exception {
		List<EgovMap> codeList = trbox.selectTransferCodeList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/getTrBoxSingleTransfer.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> getTrBoxSingleTransfer(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVo)
			throws Exception {
		int userId = sessionVo.getUserId();
		params.put("userid", userId);

		String transitno = trbox.getTrBoxSingleTransfer(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(transitno);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/getSearchTrboxReceiveList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> getSearchTrboxReceiveList(@RequestBody Map<String, Object>params, HttpServletRequest request, ModelMap model)
			throws Exception {



		List<EgovMap> list = trbox.selectTrboxReceiveList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/getSearchTrboxReceiveViewData.do", method = RequestMethod.GET)
	public ResponseEntity<Map> getSearchTrboxReceiveViewData(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model)
			throws Exception {

		Map<String, Object> list = trbox.selectReceiveViewData(params);

		list.put("transitid", params.get("trnsitid"));

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/getSearchTrboxReceiveGridList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSearchTrboxReceiveGridList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model)
			throws Exception {

		List<EgovMap> list = trbox.getSearchTrboxReceiveGridList(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/postTrboxReceiveInsertData.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> postTrboxReceiveInsertData(@RequestBody Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVo)
			throws Exception {

		int userId = sessionVo.getUserId();

		params.put("userid", userId);

		Map<String, Object> map = trbox.postTrboxReceiveInsertData(params);

		String msg = "";
//		Transit result successfully saved.
//		This transit was closed.
		String code = "";
		if ("000".equals((String)map.get("code"))){
			code = AppConstants.SUCCESS;
			msg = "Transit result successfully saved.<br>This transit was closed.";
		}else{
			code = AppConstants.FAIL;
			msg = "Failed to save. Please try again later.";
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(code);
		message.setMessage(messageAccessor.getMessage(msg));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/postTrboxTransferInsertData.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> postTrboxTransferInsertData(@RequestBody Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVo)
			throws Exception {

		int userId = sessionVo.getUserId();

		params.put("userid", userId);

		Map<String, Object> map = trbox.postTrboxTransferInsertData(params);

		String msg = "";

		String code = "";
		if ("000".equals((String)map.get("code"))){
			code = AppConstants.SUCCESS;
			msg = "Selected TR box(s) successfully transfer to courier.";
		}else{
			code = AppConstants.FAIL;
			msg = "Failed to save. Please try again later.";
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(code);
		message.setData((String)map.get("docfullno"));
		message.setMessage(messageAccessor.getMessage(msg));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/getSearchUnkeepTRBookList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> getSearchUnkeepTRBookList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model)
			throws Exception {

		String addTRbookno = request.getParameter("addTRbookno");
		String addTRreceiptNo      = request.getParameter("addTRreceiptNo");
		String status      = request.getParameter("status");


		Map<String, Object> pmap = new HashMap();
		pmap.put("addTRbookno", addTRbookno);
		pmap.put("addTRreceiptNo"     , addTRreceiptNo     );
		pmap.put("status"     , status     );

		logger.debug("91Line :::: {}" , pmap);
		List<EgovMap> list = trbox.selectUnkeepTRBookList(pmap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/KeepAddTRBookInsert.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> KeepAddTRBookInsert(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVo)
			throws Exception {
		int userId = sessionVo.getUserId();
		params.put("userid", userId);
		trbox.KeepAddTRBookInsert(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
}
