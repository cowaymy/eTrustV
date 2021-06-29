package com.coway.trust.web.organization.organization;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.biz.organization.organization.MemberHospitalizeService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.excel.MemberHospitalizeDataVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class MemberHospitalizeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MemberHospitalizeController.class);

	@Autowired
	private CsvReadComponent csvReadComponent;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "memberHospitalizeService")
	private MemberHospitalizeService memberHospitalizeService;

	 @RequestMapping(value = "/hospitalizeUpload.do")
   public String hospitalizeUpload(@RequestParam Map<String, Object> params) throws Exception {

	   return "organization/organization/memberHospitalizeUploadList";
   }

   @RequestMapping(value = "/selectHospitalizeUploadList.do", method = RequestMethod.GET)
   public ResponseEntity<List<EgovMap>> selectHospitalizeUploadList(@RequestParam Map<String, Object> params,HttpServletRequest request) {

     String[] type   = request.getParameterValues("typeList");
     String[] memberType = request.getParameterValues("memberTypeList");
     String[] status = request.getParameterValues("statusList");

     if(type != null       && !CommonUtils.containsEmpty(type))       params.put("type", type);
     if(memberType != null && !CommonUtils.containsEmpty(memberType)) params.put("memberType", memberType);
     if(status != null     && !CommonUtils.containsEmpty(status))     params.put("status", status);

     List<EgovMap> list = memberHospitalizeService.selectHospitalizeUploadList(params);

     return ResponseEntity.ok(list);
   }

   @RequestMapping(value = "/selectHospitalizeDetails.do", method = RequestMethod.GET)
   public ResponseEntity<List<EgovMap>> selectHospitalizeDetails(@RequestParam Map<String, Object> params,HttpServletRequest request) {
     List<EgovMap> list = memberHospitalizeService.selectHospitalizeDetails(params);
     return ResponseEntity.ok(list);
   }

   @RequestMapping(value = "/hospitalizeExistedCnt.do")
   public ResponseEntity<Integer> hospitalizeExistedCnt(@RequestParam Map<String, Object> params) {

     params.put("statusId", 1); //Active
     return ResponseEntity.ok(memberHospitalizeService.cntUploadBatch(params));
   }

   @RequestMapping(value = "/hospitalizeUploadFile.do", method = RequestMethod.POST)
   public ResponseEntity<Integer> readExcel(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {

     Map<String, MultipartFile> fileMap = request.getFileMap();
     MultipartFile multipartFile = fileMap.get("csvFile");

     List<MemberHospitalizeDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, MemberHospitalizeDataVO::create);

     SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
     String loginId = String.valueOf(sessionVO.getUserId());

     //master
     Map<String, Object> mMap = new HashMap<>();

     mMap.put("uploadID",request.getParameter("type"));
     mMap.put("statusID","1");
     mMap.put("actionDate",CommonUtils.getCalMonth(0).substring(0,6));
     mMap.put("creator",loginId);
     mMap.put("updator",loginId);
     mMap.put("memberTypeID",request.getParameter("memberType"));

     memberHospitalizeService.insertHospitalizeMaster(mMap);

     int uploadId = Integer.valueOf(mMap.get("seq").toString());

     List<Map<String, Object>> list = vos.stream().map(r -> {
       Map<String, Object> map = BeanConverter.toMap(r);
       map.put("userMemberCode", r.getMemberCode());
       return map;
   }).collect(Collectors.toList());

     Map<String, Object> bulkMap = new HashMap<>();
     bulkMap.put("seq", uploadId);
     bulkMap.put("list", list.stream().collect(Collectors.toCollection(ArrayList::new)));
     bulkMap.put("updator", loginId);
     bulkMap.put("memberTypeID",request.getParameter("memberType"));
     memberHospitalizeService.insertHospitalizeDetails(bulkMap);


     return ResponseEntity.ok(uploadId);
   }

   @RequestMapping(value = "/hspitalizeConfirm.do")
   public ResponseEntity<ReturnMessage> incentiveConfirm(@RequestParam Map<String, Object> params, SessionVO sessionVO) {
     ReturnMessage message = new ReturnMessage();

     params.put("userId", sessionVO.getUserId());

     memberHospitalizeService.callCnfmHsptalize(params);

     String msg = null;
     if(params.get("v_sqlcode") != null)
       msg = "("+ params.get("v_sqlcode") +")"+ params.get("v_sqlcont");

     message.setMessage(msg);
     return ResponseEntity.ok(message);
   }

   @RequestMapping(value = "/deactivateHspitalize.do")
   public ResponseEntity<ReturnMessage> incentiveDeactivate(@RequestParam Map<String, Object> params, SessionVO sessionVO) {
     ReturnMessage message = new ReturnMessage();

     params.put("userId", sessionVO.getUserId());
     params.put("statusId", 8);

     memberHospitalizeService.deactivateHspitalize(params);

     return ResponseEntity.ok(message);
   }

}
