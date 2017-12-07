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
	
	@RequestMapping(value = "/getSearchTrboxManagementList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> getSearchTrboxManagementList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model)
			throws Exception {
		
		String trbxnumber = request.getParameter("trbxnumber");
		String sdate      = request.getParameter("sdate");
		String edate      = request.getParameter("edate");
		String crtuser    = request.getParameter("crtuser");
		
		String[] status   = request.getParameterValues("status");
		String branchid   = request.getParameter("branchid");
		
		Map<String, Object> pmap = new HashMap();
		pmap.put("trbxnumber", trbxnumber);
		pmap.put("sdate"     , sdate     );
		pmap.put("edate"     , edate     );
		pmap.put("crtuser"   , crtuser   );
		pmap.put("status"    , status    );
		pmap.put("branchid"  , branchid  );
		
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

		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/getSearchTrboxReceiveGridList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSearchTrboxReceiveGridList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model)
			throws Exception {
		
		List<EgovMap> list = trbox.getSearchTrboxReceiveGridList(params);

		return ResponseEntity.ok(list);
	}
	
}
