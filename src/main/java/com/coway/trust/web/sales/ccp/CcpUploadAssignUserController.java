/**
 *
 */
package com.coway.trust.web.sales.ccp;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.ccp.CcpUploadAssignUserService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author HQIT-HUIDING
 * @date Jun 14, 2021
 *
 */
@Controller
@RequestMapping(value = "/sales/ccp")
public class CcpUploadAssignUserController {

	private static final Logger logger = LoggerFactory.getLogger(CcpUploadAssignUserController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private CsvReadComponent csvReadComponent;

	@Resource(name = "ccpUploadAssignUserService")
	private CcpUploadAssignUserService ccpUploadAssignUserService;

	@RequestMapping(value = "/ccpUploadAssignUser.do")
	public String uploadAssignUser (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		return "sales/ccp/ccpUploadAssignUser";
	}

	@RequestMapping(value = "/ccpUploadAssignUserPop.do")
	public String ccpCHSFileUploadPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		return "sales/ccp/ccpUploadAssignUserPop";
	}

	@RequestMapping(value = "/ccpCsvUpload.do", method = RequestMethod.POST)
	public ResponseEntity uploadCsv(MultipartHttpServletRequest request,SessionVO sessionVO) throws IOException, InvalidFormatException {

		ReturnMessage message = new ReturnMessage();
	    Map<String, MultipartFile> fileMap = request.getFileMap();
	    //logger.info("###fileMap: " + fileMap.toString());

	    MultipartFile multipartFile = fileMap.get("csvFile");
	    String filename = multipartFile.getOriginalFilename();
	    List<CcpUploadAssignUserVO> vos = csvReadComponent.readCsvToList(multipartFile, true, CcpUploadAssignUserVO::create);

	    logger.info("###filename: " + filename);

	    List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
	    for (CcpUploadAssignUserVO vo : vos){

	    	HashMap<String, Object> hm = new HashMap<String, Object>();

	    	hm.put("orderNo", vo.getOrderNo().trim());
	    	hm.put("memberCode", vo.getUsername().trim());
	    	hm.put("remarks", vo.getRemarks().trim());

	    	detailList.add(hm);

	    }

	    Map<String, Object> master = new HashMap<String, Object>();

	    master.put("filename", filename);
	    master.put("status", 1);
	    master.put("qty", vos.size());
	    master.put("crtUserId", sessionVO.getUserId());
	    master.put("successQty", 0);
	    master.put("failQty", 0);

	    int result = ccpUploadAssignUserService.saveCsvUpload(master, detailList);
	    if (result > 0){
	    	 message.setMessage("CCP Assign user file successfully uploaded.<br />Batch ID : "+result);
	         message.setCode(AppConstants.SUCCESS);
	    } else {
	    	message.setMessage("Failed to upload file. Please try again later.");
	        message.setCode(AppConstants.FAIL);
	    }

	    return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectCcpUploadAssignUserList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCcpUploadAssignUserList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

	      List<EgovMap> list = ccpUploadAssignUserService.selectCcpAssignUserMstList(params);

	      logger.debug("### list " + list.toString());
	      return ResponseEntity.ok(list);
	  }

	@RequestMapping(value = "/ccpUploadAssignUserDtlPop.do")
	  public String ccpCHSDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
	      logger.debug("### params : " + params);

	      EgovMap viewInfo = ccpUploadAssignUserService.selectCcpAssignUserDtlList(params);

	      model.addAttribute("viewInfo", viewInfo);
	      model.addAttribute("batchDtlList", new Gson().toJson(viewInfo.get("batchDtlList")));

	      return "sales/ccp/ccpUplAssUserDtlViewPop";
	  }

	@RequestMapping(value = "/ccpUploadReAssignUserDtlPop.do")
	  public String ccpUploadReAssignUserDtlPop(@RequestParam Map<String, Object> params, ModelMap model) {
	      logger.debug("### params : " + params);

	      EgovMap viewInfo = ccpUploadAssignUserService.selectCcpReAssignUserDtlList(params);

	      model.addAttribute("viewInfo", viewInfo);
	      model.addAttribute("batchDtlList", new Gson().toJson(viewInfo.get("batchDtlList")));

	      return "sales/ccp/ccpUplReAssUserDtlViewPop";
	  }

		@RequestMapping(value = "/selectUploadCcpUsertList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectUploadCcpUsertList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

	      List<EgovMap> list = ccpUploadAssignUserService.selectUploadCcpUsertList(params);

	      logger.debug("### list " + list.toString());
	      return ResponseEntity.ok(list);
	  }

		 @RequestMapping(value = "/updateAssignUserCcpList", method = RequestMethod.GET)
		  public ResponseEntity<EgovMap>updateAssignUserCcpList(@RequestParam Map<String, Object> params,
		      HttpServletRequest request, ModelMap model) {

			 int ccpUserList = 0;

				if(null != params.get("orderNoList")){
					String olist = (String)params.get("orderNoList");
					String[] spl = olist.split(",");
					params.put("orderNoList", spl);
				}

		    ccpUserList = ccpUploadAssignUserService.updateUploadCcpUsertList(params);
		    ccpUserList = ccpUploadAssignUserService.updateCcpCalculationPageUser(params);

		    EgovMap list= ccpUploadAssignUserService.selectCcpReAssignUserDtlList(params);

			return ResponseEntity.ok(list);
		  }

}
