package com.coway.trust.web.logistics.importbl;

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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.importbl.ImportService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/importbl")
public class ImportController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "importService")
	private ImportService importService;

	@RequestMapping(value = "/ImportBL.do")
	public String importBL(@RequestParam Map<String, Object> params, ModelMap model) {
		return "logistics/importbl/importBL";
	}

	@RequestMapping(value = "/ImportLocationList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> LocationList(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		List<EgovMap> data = importService.importLocationList(params);
		return ResponseEntity.ok(data);
	}

	@RequestMapping(value = "/ImportBLList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> importBLList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
		String invno = request.getParameter("invno");
		String blno = request.getParameter("blno");
		String[] location = request.getParameterValues("location");
		String grsdt = request.getParameter("grsdt");
		String gredt = request.getParameter("gredt");
		String blsdt = request.getParameter("blsdt");
		String bledt = request.getParameter("bledt");
		String pono = request.getParameter("pono");
		String status = request.getParameter("status");
		String materialcode  = request.getParameter("materialcode");
		String[] smattype      = request.getParameterValues("smattype");
		String[] smatcate      = request.getParameterValues("smatcate");


		Map<String, Object> pmap = new HashMap();
		pmap.put("invno", invno);
		pmap.put("blno", blno);
		pmap.put("location", location);
		pmap.put("grsdt", grsdt);
		pmap.put("gredt", gredt);
		pmap.put("blsdt", blsdt);
		pmap.put("bledt", bledt);
		pmap.put("pono", pono);
		pmap.put("status", status);
		pmap.put("materialcode"  , materialcode);
		pmap.put("smattype"      , smattype    );
		pmap.put("smatcate"      , smatcate    );

		List<EgovMap> list = importService.importBLList(pmap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	/*public ResponseEntity<ReturnMessage> importBLList(@RequestBody Map<String, Object> params, Model model) {
	List<EgovMap> dataList = importService.importBLList(params);
	ReturnMessage message = new ReturnMessage();
	message.setCode(AppConstants.SUCCESS);
	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	message.setDataList(dataList);
	return ResponseEntity.ok(message);
}*/
	@RequestMapping(value = "/searchSMO.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> searchSMO(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) {
		// params.put("userId", sessionVo.getUserId());
		List<EgovMap> dataList = importService.searchSMO(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(dataList);
		return ResponseEntity.ok(message);
	}


}
