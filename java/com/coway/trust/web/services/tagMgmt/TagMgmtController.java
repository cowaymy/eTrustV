package com.coway.trust.web.services.tagMgmt;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.enquiry.EnquiryService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.tagMgmt.TagMgmtService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.web.services.servicePlanning.MileageCalculationController;
import com.coway.trust.biz.common.AdaptorService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 09/12/2019    ONGHC      1.0.1       - RE-STRUCTURE TagMgmtController
 *                                      - ADD FILE UPLOAD FUNCTION
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/services/tagMgmt")
public class TagMgmtController {

  private static final Logger logger = LoggerFactory.getLogger(MileageCalculationController.class);

  @Value("${web.resource.upload.file}")
  private String uploadDir;

  @Resource(name = "tagMgmtService")
  TagMgmtService tagMgmtService;

  @Resource(name = "orderDetailService")
   private OrderDetailService orderDetailService;

  @Autowired
  private AdaptorService adaptorService;

  @Resource(name = "EnquiryService")
  private EnquiryService enquiryService;

  @Autowired
  private FileApplication fileApplication;

  @RequestMapping(value = "/tagManagement.do")
  public String viewTagMangement(@RequestParam Map<String, Object> params, ModelMap model) {
    model.addAttribute("params", params);

    List<EgovMap> tMgntStat = tagMgmtService.getTagMgntStat(params);
    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    model.addAttribute("tMgntStat", tMgntStat);

    return "services/tagMgmt/tagMgmtList";
  }

  @RequestMapping(value = "/tagLogRegistPop.do")
  public String viewTagLogRegistPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
    model.addAttribute("params", params);

    EgovMap tagMgmtDetail = tagMgmtService.getDetailTagStatus(params);
    model.addAttribute("tagMgmtDetail", tagMgmtDetail);

    List<EgovMap> remarks = tagMgmtService.getTagRemark(params);
    model.addAttribute("remarks", remarks);

    EgovMap orderInfo = tagMgmtService.getOrderInfo(tagMgmtDetail);
    model.addAttribute("orderInfo", orderInfo);

    EgovMap callerInfo = tagMgmtService.getOrderInfo(tagMgmtDetail);
    model.addAttribute("callerInfo", callerInfo);

    EgovMap salesmanInfo = tagMgmtService.selectOrderSalesmanViewByOrderID(orderInfo);
    model.addAttribute("salesmanInfo", salesmanInfo);

    EgovMap codyInfo = tagMgmtService.selectOrderServiceMemberViewByOrderID(orderInfo);
    model.addAttribute("codyInfo", codyInfo);

    List<EgovMap> tMgntStat = tagMgmtService.getTagMgntStat(params);
    model.addAttribute("tMgntStat", tMgntStat);

    if (orderInfo != null) {
      params.put("salesOrderId", orderInfo.get("salesOrdId"));

      EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
      model.put("orderDetail", orderDetail);
    }

    return "services/tagMgmt/tagLogListPop";
  }

  @RequestMapping(value = "/selectTagStatus")
  ResponseEntity<List<EgovMap>> getTagStatus(@RequestParam Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {
    String[] statusList = request.getParameterValues("statusList");
    String[] sub_department = request.getParameterValues("sub_department");
    params.put("listStatus", statusList);
    params.put("sub_department", sub_department);

    List <String> cmCode= new ArrayList<String>();
    if("MD08".equals(params.get("main_department"))){
        	params.put("sub_dept",sub_department);
        	params.put("mainDept", params.get("main_department"));
    		List <EgovMap> cmGroupList = tagMgmtService.selectCmGroup(params);

    		if("".equals(params.get("cmGroup"))){
    			for(EgovMap s : cmGroupList){
        			cmCode.add((String) s.getValue(0));
        		}
    		}else {
    			cmCode.add((String)params.get("cmGroup"));
    		}


    	    Object[] commaCm= cmCode.toArray();
    		params.put("cmGroup", commaCm);

    }

    if (sessionVO.getUserTypeId() == 2) {
    	params.put("isCD", sessionVO.getUserMemCode());
    }

    List<EgovMap> notice = tagMgmtService.getTagStatus(params);
    return ResponseEntity.ok(notice);
  }

  @RequestMapping(value = "/getRemarkResults.do")
  ResponseEntity<List<EgovMap>> getRemarks(@RequestParam Map<String, Object> params) {
    List<EgovMap> remarks = tagMgmtService.getTagRemark(params);
    return ResponseEntity.ok(remarks);
  }

  @RequestMapping(value = "/addRemarkResult.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> addRemarkResult(MultipartHttpServletRequest request,
      @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

    ReturnMessage message = new ReturnMessage();

    logger.debug("== TAG MANAGEMENT SAVE PARAM {} ", params);

    List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "hqTagMngmt" + File.separator + "hqTagMngmt", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

    params.put("userId", sessionVO.getUserId());
    params.put("branchId", sessionVO.getUserBranchId());
    params.put("deptId", sessionVO.getUserDeptId());
    params.put("list", list);

    logger.debug("== TAG MANAGEMENT FILE LISTING {} ", list);
    logger.debug("== TAG MANAGEMENT FILE SIZE " + list.size());

    if (list.size() > 0) {
      params.put("fileName", list.get(0).getServerSubPath() + list.get(0).getFileName());
      int fileGroupKey = fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
      params.put("atchFileGrpId", fileGroupKey);
    }

    int remarkResult = tagMgmtService.addRemarkResult(params, sessionVO);

    if (remarkResult == 2) {
      message.setMessage("Result update sucessfully.");
    } else {
      message.setMessage("Fail to update result.");
    }

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectMainDept.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getMainDeptList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> mainDeptList = tagMgmtService.getMainDeptList();
    return ResponseEntity.ok(mainDeptList);
  }

  @RequestMapping(value = "/selectSubDept.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSubDept(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    List<EgovMap> subDeptList = tagMgmtService.getSubDeptList(params);
    return ResponseEntity.ok(subDeptList);
  }

  @RequestMapping(value = "/selectSubDeptCodySupport.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSubDeptCodySupport(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) {
	  params.put("memId", sessionVO.getMemId());
	  params.put("memLvl", sessionVO.getMemberLevel());
    List<EgovMap> subDeptListCodySupport = tagMgmtService.getSubDeptListCodySupport(params, sessionVO);
    return ResponseEntity.ok(subDeptListCodySupport);
  }

  /**
   * to get CM Group by Branch
   *
   * @Date Dec 17, 2020
   * @Author HQIT-HUIDING
   * @param params
   * @param request
   * @param model
   * @return
   */
  @RequestMapping(value = "/selectCmGroup.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getCmGroup(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model){

	  /*String groupCode = null;
	  String deptCode = null;*/
/*	System.out.println(params.get("subDept"));
	String[] sub_department = request.getParameterValues("subDept");
	System.out.println("check point2");
	System.out.println(sub_department);
	params.put("subDept", sub_department);*/

	  	logger.info("selectStockLocationList: {}", params);

		String searchgb = (String) params.get("sub_dept");
		String[] searchgbvalue = searchgb.split("∈");
		logger.debug(" :::: {}", searchgbvalue.length);

		params.put("sub_dept", searchgbvalue);

	  List<EgovMap> cmGroupList = tagMgmtService.selectCmGroup(params);
	  return ResponseEntity.ok(cmGroupList);
  }

  /**
   * To get Default CM Group by Login ID
   *
   * @Date Dec 18, 2021
   * @Author HQIT-HUIDING
   * @param params
   * @param request
   * @param model
   * @return
   */
  @RequestMapping(value = "/getDefaultCmGrp.do", method = RequestMethod.GET)
  public ResponseEntity<Map> getDefaultCmGroup(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO){

	  Map<String, Object> defaultCmMap = null;

	  Map<String, Object> userMap = new HashMap<String, Object>();
	  String username = sessionVO.getUserName();
	  userMap.put("username", username);

	  EgovMap defaultCmGroup = tagMgmtService.selectCmGroupByUsername(userMap);
	  logger.info("####defaultCmGroup: " + defaultCmGroup.toString());

	  if (defaultCmGroup != null && defaultCmGroup.get("lastDeptCode")!= null){
		  defaultCmMap = new HashMap<String, Object> ();
		  defaultCmMap.put("defCmGrp", defaultCmGroup.get("lastDeptCode"));
	  }

	  return ResponseEntity.ok(defaultCmMap);
  }

  @RequestMapping(value = "/selectMainInquiry.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getMainInquiryList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> mainInquiryList = tagMgmtService.getMainInquiryList();

    return ResponseEntity.ok(mainInquiryList);
  }

  @RequestMapping(value = "/selectSubInquiry.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSubInquiryList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> subInquiryList = tagMgmtService.getSubInquiryList(params);

    return ResponseEntity.ok(subInquiryList);
  }

  @RequestMapping(value = "/selectAttachList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAttachList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> attachList = tagMgmtService.getAttachList(params);

    return ResponseEntity.ok(attachList);
  }

  @RequestMapping(value = "/selectAttachList2.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAttachList2(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> attachList = tagMgmtService.getAttachList2(params);

    return ResponseEntity.ok(attachList);
  }

  @RequestMapping(value = "/updateInstalaltionAddress.do")
  public String updateInstalaltionAddress(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> tMgntStat = tagMgmtService.getUpdInstllationStat(params);
    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    model.addAttribute("tMgntStat", tMgntStat);

    return "services/tagMgmt/updateInstalaltionAddress";
  }

  @RequestMapping(value = "/selectUpdateInstallationAddressRequest")
  ResponseEntity<List<EgovMap>> selectUpdateInstallationAddressRequest(@RequestParam Map<String, Object> params, HttpServletRequest request) {
    String[] statusList = request.getParameterValues("statusList");
    params.put("listStatus", statusList);
    logger.info("param"+params);
    List<EgovMap> notice = tagMgmtService.selectUpdateInstallationAddressRequest(params);
    return ResponseEntity.ok(notice);
  }

  @Transactional
  @RequestMapping(value = "/approveInstallationAddressRequest.do")
  public ResponseEntity<ReturnMessage> approveInstallationAddressRequest(@RequestBody Map<String, Object> params , SessionVO session) throws Exception{

	  try{
		    ReturnMessage message = new ReturnMessage();

		    int result = 0, result2= 0 , result3=0;

		    List<Object> updateList = (List<Object>) params.get("param");

		    for (int i = 0; i < updateList.size(); i++) {
		    	Map<String, Object> insMap = (Map<String, Object>) updateList.get(i);
		    	insMap.put("crtUserId", session.getUserId());
		    	result = tagMgmtService.insertInstallAddress(insMap);
		    	result2 = tagMgmtService.updateInstallInfo(insMap);
		    	result3 = tagMgmtService.updateRequestStatus(insMap);

				if (result > 0 && result2 > 0 && result3 > 0) {
					setEmailData(insMap);
			    }
				else {
    				message.setMessage("Failed to approve. Please try again later.");
    				message.setCode(AppConstants.FAIL);
    				throw new Error("Unable to update");
				}
		    }
	    	message.setCode(AppConstants.SUCCESS);
	    	message.setMessage("Success to approve.");
			return ResponseEntity.ok(message);
	  }
	  catch(Exception e){
		  throw e;
	  }
  }

	 private void setEmailData(Map<String, Object> params) {

		  EgovMap getEmailDetails = tagMgmtService.getEmailDetails(params);
		  List<String> emailList = Arrays.asList("callcenter@coway.com.my");
		  String street = getEmailDetails.get("street").equals("0") ? "" : getEmailDetails.get("street").toString() ;

		  Map<String, Object> emailDetail = new HashMap<String,Object>();
		  List<Map<String, Object>> emailDetailList = new ArrayList<Map<String,Object>>();
		  emailDetail.put("orderNo", getEmailDetails.get("orderNo").toString());
		  emailDetail.put("customerName", getEmailDetails.get("name").toString());
		  emailDetail.put("mobileNo", getEmailDetails.get("phoneNo").toString());
		  emailDetail.put("address", getEmailDetails.get("addrDtl").toString() + street + " " + getEmailDetails.get("area").toString());
		  emailDetail.put("postCode", getEmailDetails.get("postcode").toString());
		  emailDetail.put("city", getEmailDetails.get("city").toString());
		  emailDetail.put("state", getEmailDetails.get("state").toString());
		  emailDetail.put("requestDt", getEmailDetails.get("requestDt").toString());
		  emailDetail.put("email", emailList);
		  emailDetail.put("emailSubject", "Approved Installation Address Request");

		 this.sendEmail(emailDetail);
	 }

	 private void sendEmail(Map<String, Object> params) {

    		 try{
    	    	List<Map<String, Object>> emailList =  (List<Map<String, Object>>) params.get("email");

            	    	for(int i = 0 ;i< emailList.size();i++){
                	            EmailVO email = new EmailVO();

                	            String emailSubject = params.get("emailSubject").toString();

                	            List<String> emailNo = new ArrayList<String>();

                	            if (!"".equals(CommonUtils.nvl(emailList.get(i)))) {
                	            	emailNo.add(CommonUtils.nvl(emailList.get(i)));
                	            }

                	            String content = "";
                	            content += "<table style='border-collapse: collapse;width: 100%;'>";
                	            content += "<tr><th colspan='2' style='background-color: #3BC3FF;padding: 12px;color: white;text-align: left'>Approved Update Installation Address Request </th><tr>";
                	            content +="<tr><td style='padding: 8px'>Full Name : </td>";
                	            content +="<td>"+params.get("customerName").toString()+"</td></tr>";

                	            content +="<tr><td style='padding: 8px'>Order No : </td>";
                	            content +="<td>"+params.get("orderNo").toString()+"</td></tr>";

                	            content +="<tr><td style='padding: 8px'>Mobile No : </td>";
                	            content +="<td>"+params.get("mobileNo").toString()+"</td></tr>";

                	            content +="<tr><td style='padding: 8px'>Address : </td>";
                	            content +="<td>"+params.get("address").toString()+"</td></tr>";

                	            content +="<tr><td style='padding: 8px'>Postcode : </td>";
                	            content +="<td>"+params.get("postCode").toString()+"</td></tr>";

                	            content +="<tr><td style='padding: 8px'>City : </td>";
                	            content +="<td>"+params.get("city").toString()+"</td></tr>";

                	            content +="<tr><td style='padding: 8px'>State : </td>";
                	            content +="<td>"+params.get("state").toString()+"</td></tr>";

                	            content +="<tr><td style='padding: 8px'>Request Dt : </td>";
                	            content +="<td>"+params.get("requestDt").toString()+"</td></tr>";

                	            email.setTo(emailNo);
                	            email.setHtml(true);
                	            email.setSubject(emailSubject);
                	            email.setText(content);
                	            adaptorService.sendEmail(email, false);
            	    	}
    		 }
		 	catch(Exception e){
    			  Map<String, Object> errorParam = new HashMap<>();
    			  errorParam.put("pgmPath","/services/tagMgmt");
    			  errorParam.put("functionName", "sendEmail.do");
    			  errorParam.put("errorMsg",e.toString());
    			  enquiryService.insertErrorLog(errorParam);
		 	}
	    }


}
