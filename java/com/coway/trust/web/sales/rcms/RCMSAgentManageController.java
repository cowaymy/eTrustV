package com.coway.trust.web.sales.rcms;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.rcms.RCMSAgentManageService;
import com.coway.trust.biz.sales.rcms.vo.uploadAssignAgentDataVO;
import com.coway.trust.biz.sales.rcms.vo.uploadAssignConvertVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/sales/rcms")
public class RCMSAgentManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(RCMSAgentManageController.class);

	@Resource(name = "rcmsAgentManageService")
	private RCMSAgentManageService rcmsAgentService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private CsvReadComponent csvReadComponent;

	@Autowired
	private SessionHandler sessionHandler;


	@RequestMapping(value = "/selectRcmsAgentList.do")
	public String selectRcmsAgentList (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/rcms/rcmsAgentManagementList";
	}

	@RequestMapping(value = "/rcmsAssignAgentList.do")
	public String rcmsAssignAgent (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/rcms/rcmsAssignAgentList";
	}
	@RequestMapping(value = "/uploadAssignAgentPop.do")
	public String uploadAgentPop (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/rcms/uploadAssignAgentPop";
	}
	@RequestMapping(value = "/updateRemarkPop.do")
	public String updateRemarkPop (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/rcms/updateRemarkPop";
	}
	@RequestMapping(value = "/rcmsAssignmentConversion.do")
	public String rcmsAssignedList (@RequestParam Map<String, Object> params) throws Exception{

		return "sales/rcms/rcmsAssignmentConversion";
	}

	@RequestMapping(value = "/selectAgentTypeList")
	public ResponseEntity<List<EgovMap>> selectAgentTypeList (@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> agentList = null;

		agentList = rcmsAgentService.selectAgentTypeList(params);

		return ResponseEntity.ok(agentList);
	}


	@RequestMapping(value = "/checkWebId")
	public ResponseEntity<List<Object>> checkWebId (@RequestBody Map<String, Object> params) throws Exception{

		List<Object> resultList = rcmsAgentService.checkWebId(params);

		return ResponseEntity.ok(resultList);
	}



	@RequestMapping(value = "/chkDupWebId")
	public ResponseEntity<List<Object>> chkDupWebId (@RequestBody Map<String, Object> params) throws Exception{

		List<Object> resultList = rcmsAgentService.chkDupWebId(params);

		return ResponseEntity.ok(resultList);
	}


	@RequestMapping(value = "/insUpdAgent.do")
	public ResponseEntity<ReturnMessage> insUpdAgent(@RequestBody Map<String, Object> params , SessionVO session) throws Exception{

		params.put("crtUserId", session.getUserId());
		rcmsAgentService.insUpdAgent(params);

		//Return Message
		ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/selectAgentList")
	public ResponseEntity<List<EgovMap>> selectAgentList (@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{

		List<EgovMap> agentList = null;

		String typeArr[] =  request.getParameterValues("agentType");
		String statusArr[] = request.getParameterValues("agentStatus");

		params.put("typeList", typeArr);
		params.put("statusList", statusArr);

		agentList = rcmsAgentService.selectAgentList(params);

		return ResponseEntity.ok(agentList);

	}

	@RequestMapping(value = "/selectAgentGrpList")
	public ResponseEntity<List<EgovMap>> selectAgentGrpList (@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		List<EgovMap> agentGrpList = null;

		String typeList[] =  request.getParameterValues("agentType");
		if(typeList      != null && !CommonUtils.containsEmpty(typeList))      params.put("typeList", typeList);

		agentGrpList = rcmsAgentService.selectAgentGrpList(params);


		return ResponseEntity.ok(agentGrpList);
	}

	@RequestMapping(value = "/selectRosCaller")
	public ResponseEntity<List<EgovMap>> selectRosCaller (@RequestParam Map<String, Object> params) throws Exception{

		LOGGER.debug("param ===================>>  " + params);
		List<EgovMap> rosCallertList = null;

		rosCallertList = rcmsAgentService.selectRosCaller(params);

		return ResponseEntity.ok(rosCallertList);

	}

	@RequestMapping(value = "/selectAssignAgentList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAssignAgentList (@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("param ===================>>  " + params);

		String rentalStatus[] = request.getParameterValues("rentalStatus");
		String companyType[] = request.getParameterValues("companyType");
		String openMonth[] = request.getParameterValues("openMonth");
		String rosCaller[] = request.getParameterValues("rosCaller");
		String raceId[] = request.getParameterValues("raceId");
		String payMode[] = request.getParameterValues("payMode");
		String productCategory[] = request.getParameterValues("productCategory");
		for (String str : openMonth){

			if("7".equals(str)){

				params.put("month", "8");
			}

		}


		params.put("rentalStatus", rentalStatus);
		params.put("companyType", companyType);
		params.put("openMonth", openMonth);
		params.put("rosCaller", rosCaller);
		params.put("raceId", raceId);
		params.put("payMode", payMode);
		params.put("productCategory", productCategory);

		List<EgovMap> assignAgentList = null;

		assignAgentList = rcmsAgentService.selectAssignAgentList(params);

		return ResponseEntity.ok(assignAgentList);

	}

	@RequestMapping(value = "/saveAssignAgent", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAssignAgent(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

		LOGGER.debug("param ===================>>  " + params);

		params.put("userId", sessionVO.getUserId());

		rcmsAgentService.saveAssignAgent(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData("");
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/checkAgentList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> checkAgentList(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

		LOGGER.debug("param ===================>>  " + params);

		List<EgovMap> chkList = rcmsAgentService.checkAssignAgentList(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(chkList);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/saveAgentList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAgentList(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

		LOGGER.debug("param ===================>>  " + params);

		params.put("userId", sessionVO.getUserId());

		rcmsAgentService.saveAgentList(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData("");
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/selectRcmsInfo", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectRcmsInfo(@RequestParam Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

		LOGGER.debug("param ===================>>  " + params);

		EgovMap result = rcmsAgentService.selectRcmsInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(result);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/updateRemark", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateRemark(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

		LOGGER.debug("param ===================>>  " + params);

		params.put("userId", sessionVO.getUserId());
		params.put("rosCaller2", !params.get("rosCaller2").equals("") ? params.get("rosCaller2") : 0 );

		rcmsAgentService.updateRemark(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData("");
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/selectAssignConversionList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAssignConversionList (@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("param ===================>>  " + params);

		String batchStus[] = request.getParameterValues("cmbBatchStatus");

		params.put("batchStus", batchStus);

		List<EgovMap> assignConvertList = null;

		assignConvertList = rcmsAgentService.selectAssignConvertList(params);

		return ResponseEntity.ok(assignConvertList);

	}

	   @RequestMapping(value = "/selectAssignConversionItemList", method = RequestMethod.GET)
	    public ResponseEntity<List<EgovMap>> selectAssignConversionItemList (@RequestParam Map<String, Object> params,
	            HttpServletRequest request, ModelMap model) throws Exception{

	        List<EgovMap> assignConvertItemList = rcmsAgentService.selectAssignConvertItemList(params);

	        return ResponseEntity.ok(assignConvertItemList);

	    }

	@RequestMapping(value = "/selectRosCallDetailList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRosCallDetailList (@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("param ===================>>  " + params);

		List<EgovMap> rosCallDetailList = rcmsAgentService.selectRosCallDetailList(params);

		return ResponseEntity.ok(rosCallDetailList);

	}

	@RequestMapping(value = "/badAccReportPop.do")
	public String badAccReportPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/rcms/badAccReportPop";
	}

	@RequestMapping(value = "/assignListReportPop.do")
    public String assignListReportPop(@RequestParam Map<String, Object> params) throws Exception{
        return "sales/rcms/assignListReportPop";
    }

	@RequestMapping(value = "/eTRSummaryListReportPop.do")
    public String eTRSummaryListReportPop(@RequestParam Map<String, Object> params) throws Exception{
        return "sales/rcms/eTRSummaryListReportPop";
    }

	@RequestMapping(value = "/assignSummaryListReportPop.do")
    public String assignSummaryListReportPop(@RequestParam Map<String, Object> params) throws Exception{
        return "sales/rcms/assignSummaryListReportPop";
    }

	@RequestMapping(value = "/summaryDailyCollectionReportPop.do")
    public String summaryDailyCollectionReportPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		model.put("type", 0);
        return "sales/rcms/collectionReportPop";
    }

	@RequestMapping(value = "/dailyCollectionOrderReportPop.do")
    public String dailyCollectionOrderReportPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		model.put("type", 1);
        return "sales/rcms/collectionReportPop";
    }

	@RequestMapping(value = "/rentalStatusListForBadAcc")
	public ResponseEntity<List<EgovMap>> rentalStatusListForBadAcc(@RequestParam Map<String, Object> params, @RequestParam(value="codeIn[]") String codeIn[]) throws Exception{

		params.put("codes", codeIn);
		List<EgovMap> rtnList = null;
		rtnList = rcmsAgentService.rentalStatusListForBadAcc(params);

		return ResponseEntity.ok(rtnList);
	}

	@RequestMapping(value = "/checkCustAgent", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> checkCustAgent (@RequestParam Map<String, Object> params) throws Exception{

	    LOGGER.debug("param ===================>>  " + params.toString());
	    List<EgovMap> custAgent = rcmsAgentService.checkCustAgent(params);
	    return ResponseEntity.ok(custAgent);

    }

	@RequestMapping(value = "/uploadRcmsConversionBulk.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> uploadRcmsConversionBulk(MultipartHttpServletRequest request, SessionVO sessionVO) throws Exception {

        //Master 정보 세팅
        Map<String, Object> rcmsMap = new HashMap<String, Object>();
        String assignUploadType = request.getParameter("assignUploadType").toString();
        //CVS 파일 세팅
        Map<String, MultipartFile> fileMap = request.getFileMap();
        MultipartFile multipartFile = fileMap.get("csvFile");

        List<EgovMap> uploadedList = null;

        //__________________________________________________________________________________upload agent
        if(!assignUploadType.isEmpty()){
          List<uploadAssignAgentDataVO> vos = csvReadComponent.readCsvToList(multipartFile,true ,uploadAssignAgentDataVO::create);

          //CVS 파일 객체 세팅
          Map<String, Object> cvsParam = new HashMap<String, Object>();
          cvsParam.put("voList", vos);
          cvsParam.put("userId", sessionVO.getUserId());

          // cvs 파일 저장 처리
          List<uploadAssignAgentDataVO> vos2 = (List<uploadAssignAgentDataVO>) cvsParam.get("voList");

          List<Map> list = vos2.stream().map(r -> {
              Map<String, Object> map = BeanConverter.toMap(r);
              map.put("ordNo", r.getOrderNo());
              map.put("agentId", r.getCaller());
              map.put("agentGrpId", r.getCaller2());
              map.put("renStus", r.getRenStus());
              return map;
          }).collect(Collectors.toList());

          Map<String, Object> bulkMap = new HashMap<>();
          //bulkMap.put("list", list.stream().collect(Collectors.toCollection(ArrayList::new)));

          rcmsAgentService.deleteUploadedConversionList(bulkMap);

          int size = 10000;
          int page = list.size() / size;
          int start;
          int end;

          for (int i = 0; i <= page; i++) {
            start = i * size;
            end = size;

            if (i == page) {
              end = list.size();
            }
            if(list.stream().skip(start).limit(end).count() != 0){
                bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
                rcmsAgentService.insertUploadedConversionList(bulkMap);
            }
          }
          uploadedList = rcmsAgentService.selectUploadedConversionList(bulkMap);

        }else{
        //__________________________________________________________________________________upload etr/sensitive
          List<uploadAssignConvertVO> vos = csvReadComponent.readCsvToList(multipartFile,true ,uploadAssignConvertVO::create);

          //CVS 파일 객체 세팅
          Map<String, Object> cvsParam = new HashMap<String, Object>();
          cvsParam.put("voList", vos);
          cvsParam.put("userId", sessionVO.getUserId());

          // cvs 파일 저장 처리
          List<uploadAssignConvertVO> vos2 = (List<uploadAssignConvertVO>) cvsParam.get("voList");

          List<Map> list = vos2.stream().map(r -> {
              Map<String, Object> map = BeanConverter.toMap(r);
              map.put("ordNo", r.getOrderNo());
              map.put("itm", r.getItem());
              map.put("rem", r.getRemark());
              return map;
          }).collect(Collectors.toList());

          Map<String, Object> bulkMap = new HashMap<>();
          rcmsAgentService.deleteUploadedConversionList(bulkMap);

          int size = 10000;
          int page = list.size() / size;
          int start;
          int end;

          for (int i = 0; i <= page; i++) {
            start = i * size;
            end = size;

            if (i == page) {
              end = list.size();
            }
            if(list.stream().skip(start).limit(end).count() != 0){
                bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
                rcmsAgentService.insertUploadedConversionList(bulkMap);
            }
          }
          uploadedList = rcmsAgentService.selectUploadedConversionList(bulkMap);
        }

        // 결과 만들기.
        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(uploadedList);
        message.setMessage("Saved Successfully");

        return ResponseEntity.ok(message);
    }

	@RequestMapping(value = "/saveConversionList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveConversionList(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

	    params.put("userId", sessionVO.getUserId());

	    rcmsAgentService.saveConversionList(params);

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setData("");
	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	    return ResponseEntity.ok(message);

	}

	  @RequestMapping(value = "/rcmsAgentGroupManagement.do")
	  public String eshopItemRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) {

	    return "sales/rcms/rcmsAgentGroupManagement";

	  }

		@RequestMapping(value = "/selectAgentGroupList")
		public ResponseEntity<List<EgovMap>> selectAgentGroupList (@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{

			List<EgovMap> agentGrpList = null;

			agentGrpList = rcmsAgentService.selectAgentGroupList(params);

			return ResponseEntity.ok(agentGrpList);

		}

		@RequestMapping(value = "/insUpdAgentGroup.do")
		public ResponseEntity<ReturnMessage> insUpdAgentGroup(@RequestBody Map<String, Object> params , SessionVO session) throws Exception{

			params.put("crtUserId", session.getUserId());


			 LOGGER.debug("param insUpdAgentGroup===================>>  " + params.toString());

			rcmsAgentService.insUpdAgentGroup(params);

			//Return Message
			ReturnMessage message = new ReturnMessage();
	    	message.setCode(AppConstants.SUCCESS);
	    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


			return ResponseEntity.ok(message);
		}


}
