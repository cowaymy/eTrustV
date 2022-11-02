package com.coway.trust.web.logistics.asDefectPart;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.asDefectPart.asDefectPartService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/asDefectPart")
public class asDefectPartController {

	private static final Logger logger = LoggerFactory.getLogger(asDefectPartController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "asDefectPartService")
	private asDefectPartService asDefectPartService;

	@Resource(name = "accessMonitoringService")
	private AccessMonitoringService accessMonitoringService;

	@RequestMapping(value = "/asDefectPartSmallCodeList.do")
	public String asDefectPartSmallCodeList(@RequestParam Map<String, Object> params) {
		return "logistics/asDefectPart/asDefectPartSmallCodeList";
	}

	@RequestMapping(value = "/addEditViewDefectPartPop.do")
	  public String addEditViewDefectPartPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {

	    logger.debug("=====================/addEditViewDefectPartPop.do=========================");
	    logger.debug("params : {}", params);
	    logger.debug("=====================/addEditViewDefectPartPop.do=========================");

	    model.put("viewType", (String) params.get("viewType"));

	    if(params.get("viewType").equals("2") || params.get("viewType").equals("3"))
	    {
	        EgovMap asDefectPartInfo = asDefectPartService.selectAsDefectPartInfo(params);

		    model.put("defPartId", (String) params.get("defPartId"));
		    model.addAttribute("asDefectPartInfo", asDefectPartInfo);
	    }

	    return "logistics/asDefectPart/addEditViewDefectPartPop";
	  }

	@RequestMapping(value = "/searchAsDefPartList" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> searchAsDefPartList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		//Log down user search params
    	StringBuffer requestUrl = new StringBuffer(request.getRequestURI());
    	requestUrl.replace(requestUrl.lastIndexOf("/"), requestUrl.lastIndexOf("/") + 1, "/orderList.do/");
		accessMonitoringService.insertSubAccessMonitoring(requestUrl.toString(), params, request,sessionVO);

		String[] arrProductCtgry   = request.getParameterValues("productCtgry"); //Application Type
		String[] arrMatType = request.getParameterValues("matType"); //Order Status

		if(arrProductCtgry      != null && !CommonUtils.containsEmpty(arrProductCtgry))      params.put("arrProductCtgry", arrProductCtgry);
		if(arrMatType    != null && !CommonUtils.containsEmpty(arrMatType))    params.put("arrMatType", arrMatType);

		List<EgovMap> orderList =null;
		orderList = asDefectPartService.searchAsDefPartList(params);

		return ResponseEntity.ok(orderList);
	}

	@RequestMapping(value = "/saveDefPart.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> saveDefPart(@RequestBody Map<String, Object> params, Model model,
	      HttpServletRequest request, SessionVO sessionVO) {
	    logger.debug("===========================/saveDefPart.do===============================");
	    logger.debug("==params " + params.toString());
	    logger.debug("===========================/saveDefPart.do===============================");

	    Map<?, ?> svc0131map = (Map<?, ?>) params.get("asDefPartResultM");
	    logger.debug("==svc0131map " + svc0131map.toString());

	    params.put("defPartId",svc0131map.get("defPartId"));
	    params.put("viewType",svc0131map.get("viewType"));

	    params.put("productCtgry",svc0131map.get("productCtgry"));
	    params.put("matType",svc0131map.get("matType"));
	    params.put("matCode",svc0131map.get("matCode"));
	    params.put("matName",svc0131map.get("matName"));
	    params.put("defPartCode",svc0131map.get("defPartCode"));
	    params.put("defPartName",svc0131map.get("defPartName"));

	    params.put("creator", sessionVO.getUserId());
	    params.put("updator", sessionVO.getUserId());

	    EgovMap stkInfo = asDefectPartService.getStkInfo(params);

	    ReturnMessage message = new ReturnMessage();
	    if(stkInfo == null){
	    	message.setMessage("There is no " + svc0131map.get("matCode"));
	    }else{
	    	logger.debug("============STKINFO=============");
		    logger.debug(stkInfo.toString());
		    logger.debug("============STKINFO=============");

	    	params.put("matId", stkInfo.get("stkId"));

		    if(params.get("viewType").equals("1"))//NEW
		    {
		    	params.put("stus","1");
			    asDefectPartService.addDefPart(params);
			    message.setMessage("Successfully configured product code " + svc0131map.get("matCode"));
		    }
		    else //viewtype ==2 Edit, ==3 View
		    {
			    asDefectPartService.updateDefPart(params);
			    message.setMessage("Successfully update product code " + svc0131map.get("matCode"));
		    }

		    logger.debug("================saveDefPart - END ================");
		    message.setCode(AppConstants.SUCCESS);
	    }

	    return ResponseEntity.ok(message);
	  }

	@RequestMapping(value = "/updateDefPartStus.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> updateDefPartStus(@RequestBody Map<String, Object> params, Model model,
	      HttpServletRequest request, SessionVO sessionVO) {
	    logger.debug("===========================/updateDefPartStus.do===============================");
	    logger.debug("==params111 " + params.toString());
	    logger.debug("===========================/updateDefPartStus.do===============================");

	    params.put("updator", sessionVO.getUserId());
	    ReturnMessage message = new ReturnMessage();

	    String active = "1";
	    String deact = "8";

	    String stus = params.get("stusId").toString().equals("1") ? deact : active;
	    params.put("updStus", stus);

	    asDefectPartService.updateDefPartStus(params);

	    logger.debug("==params222 " + params.toString());
	    logger.debug("================updateDefPartStus - END ================");

	    message.setCode(AppConstants.SUCCESS);
	    String actMsg = stus.equals("1") ? " activated" : " deactivated";
	    message.setMessage(params.get("matCode") + " is " + actMsg);

	    return ResponseEntity.ok(message);
	  }

	@RequestMapping(value = "/checkDefPart.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> checkDefPart(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> defPartList = asDefectPartService.checkDefPart(params);
	    return ResponseEntity.ok(defPartList);
	  }

	@RequestMapping(value = "/chkDupLinkage.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> chkDupLinkage(@RequestParam Map<String, Object> params, ModelMap model) {
	    logger.debug("checkDefPart.do : {}", params);

		List<EgovMap> linkList = asDefectPartService.chkDupLinkage(params);

	    logger.debug("==linkList1111 " + linkList.toString());

	    return ResponseEntity.ok(linkList);
	  }
}
