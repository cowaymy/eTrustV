package com.coway.trust.web.sales.rcms;

import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.rcms.CorporateCareAccountMgmtService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.StringTokenizer;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/rcms")
public class CorporateCareAccountMgmtController {

	private static final Logger logger = LoggerFactory.getLogger(CorporateCareAccountMgmtController.class);

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private FileApplication fileApplication;

	@Resource(name = "corporateCareAccountMgmtService")
	private CorporateCareAccountMgmtService corporateCareAccountMgmtService;

	@RequestMapping(value = "/corporateCareAccountMgmtList.do")
	public String selectRcmsAgentList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		return "sales/rcms/corporateCareAccountMgmtList";
	}

	@RequestMapping(value = "/selectPortalNameList.do", method = RequestMethod.GET) //portal name ddl
	public ResponseEntity<List<EgovMap>> selectPortalNameList (@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{

		List<EgovMap> portalNameList = null;

		portalNameList = corporateCareAccountMgmtService.selectPortalNameList(params);
		return ResponseEntity.ok(portalNameList);
	}

	@RequestMapping(value = "/selectPortalStusList.do", method = RequestMethod.GET) //portal stus ddl
	public ResponseEntity<List<EgovMap>> selectPortalStusList (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> portalStusList = corporateCareAccountMgmtService.selectPortalStusList();
		return ResponseEntity.ok(portalStusList);
	}

	@RequestMapping(value = "/selectPICList.do", method = RequestMethod.GET) //portal PIC 1 2 3 ddl
	public ResponseEntity<List<EgovMap>> selectPICList (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> picList = corporateCareAccountMgmtService.selectPICList();
		return ResponseEntity.ok(picList);
	}

	@RequestMapping(value = "/selectPortalList") //search ???
	public ResponseEntity<List<EgovMap>> selectPortalList (@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{

		List<EgovMap> portalList = null;

		String portalNameArr[] =  request.getParameterValues("portalName");
		String statusArr[] = request.getParameterValues("portalStatus");

		params.put("portalNameList", portalNameArr);
		params.put("statusList", statusArr);

		portalList = corporateCareAccountMgmtService.selectPortalList(params);

		return ResponseEntity.ok(portalList);
	}

	@RequestMapping(value = "/selectCareAccMgmtList")//search ???
	public ResponseEntity<List<EgovMap>> selectCareAccMgmtList (@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{

		List<EgovMap> careAccMgmtList = null;

		String portalArr[] =  request.getParameterValues("_portalName");
		String statusArr[] = request.getParameterValues("_portalStatus");

		params.put("portalNameList", portalArr);
		params.put("statusList", statusArr);

		careAccMgmtList = corporateCareAccountMgmtService.selectCareAccMgmtList(params);

		return ResponseEntity.ok(careAccMgmtList);
	}

	@RequestMapping(value = "/addEditViewCorporatePortalPop.do")
	  public String addEditViewCorporatePortalPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
	    logger.debug("=====================/addEditViewCorporatePortalPop.do=========================");
	    logger.debug("params : {}", params);
	    logger.debug("=====================/addEditViewCorporatePortalPop.do=========================");

	    model.put("viewType", (String) params.get("viewType"));

	    List<EgovMap> picList = corporateCareAccountMgmtService.selectPICList();
	    model.addAttribute("picList", picList);

	    if(params.get("viewType").equals("2") || params.get("viewType").equals("3"))
	    {
	        EgovMap portalInfo = corporateCareAccountMgmtService.selectPortalDetails(params);

		    model.put("portalId", (String) params.get("portalId"));
		    model.addAttribute("portalInfo", portalInfo);
	    }

	    return "sales/rcms/addEditViewCorporatePortalPop";
	  }

	@RequestMapping(value = "/addPortalOrderPop.do") //add order to portal
	  public String addPortalOrderPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {

	    logger.debug("=====================/addPortalOrderPop.do=========================");
	    logger.debug("params : {}", params);
	    logger.debug("=====================/addPortalOrderPop.do=========================");

	    return "sales/rcms/addPortalOrderPop";
	  }

	@RequestMapping(value = "/savePortal.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> savePortal(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params,
			  Model model, SessionVO sessionVO) throws Exception {
	    logger.debug("===========================/savePortal.do===============================");
	    logger.debug("==params " + params.toString());
	    logger.debug("===========================/savePortal.do===============================");

	    if (params.get("regPeriod") != null) {
	        StringTokenizer str1 = new StringTokenizer(params.get("regPeriod").toString());

	        for (int i = 0; i <= 1; i++) {
	          str1.hasMoreElements();
	          String result = str1.nextToken("/");

	          if (i == 0) {
	            params.put("regMonth", result);
	            logger.debug("regMonth : {}", params.get("regMonth"));
	          } else {
	            params.put("regYear", result);
	            logger.debug("regYear : {}", params.get("regYear"));
	          }
	        }
	      }

	    params.put("creator", sessionVO.getUserId());
	    params.put("updator", sessionVO.getUserId());
	    ReturnMessage message = new ReturnMessage();
  		String atchSubPath = generateAttchmtSubPath();

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,atchSubPath, AppConstants.UPLOAD_MAX_FILE_SIZE, true);

	    params.put(CommonConstants.USER_ID, sessionVO.getUserId());

	    logger.debug("==list=== " + list.toString());

	    if (list.size() > 0) {
	      params.put("fileName", list.get(0).getServerSubPath() + list.get(0).getFileName());
	      int fileGroupKey = fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		  logger.debug("==fileGroupKey=== " + fileGroupKey);
	      params.put("atchFileGrpId", CommonUtils.intNvl(fileGroupKey));
	    }

	    if(params.get("viewType").equals("1"))//NEW
	    {
	    	params.put("stus","1");
	    	corporateCareAccountMgmtService.addPortal(params);
		    message.setMessage("Successfully configured product code " + params.get("portalName"));
	    }
	    else //viewtype ==2 Edit, ==3 View
	    {
	    	corporateCareAccountMgmtService.updatePortal(params);
		    message.setMessage("Successfully update product code " + params.get("portalName"));
	    }

	    logger.debug("================savePortal - END ================");
	    message.setCode(AppConstants.SUCCESS);

	    return ResponseEntity.ok(message);
	  }

	public String generateAttchmtSubPath(){
		Date today = new Date();
		SimpleDateFormat formatAttchtDt = new SimpleDateFormat("yyyyMMdd");
		String dt = formatAttchtDt.format(today);
		String subPath = File.separator + "portalGuideline" + File.separator  + dt.substring(0, 4) + File.separator + dt.substring(0, 6);
		return subPath;
	}

	@RequestMapping(value = "/updatePortalStatus.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> updatePortalStatus(@RequestBody Map<String, Object> params, Model model,
	      HttpServletRequest request, SessionVO sessionVO) {
	    logger.debug("===========================/updatePortalStatus.do===============================");
	    logger.debug("==params111 " + params.toString());
	    logger.debug("===========================/updatePortalStatus.do===============================");

	    params.put("updator", sessionVO.getUserId());
	    ReturnMessage message = new ReturnMessage();
	    String active = "1";
	    String deact = "8";
	    String stus = params.get("portalStusId").toString().equals("1") ? deact : active;
	    params.put("updStus", stus);

	    corporateCareAccountMgmtService.updatePortalStatus(params);

	    logger.debug("================updateDefPartStus - END ================");
	    message.setCode(AppConstants.SUCCESS);
	    String actMsg = stus.equals("1") ? " activated" : " deactivated";
	    message.setMessage(params.get("portalName") + " is " + actMsg);

	    return ResponseEntity.ok(message);
	  }

}
