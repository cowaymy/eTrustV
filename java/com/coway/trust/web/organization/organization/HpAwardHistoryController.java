package com.coway.trust.web.organization.organization;

import java.io.IOException;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.Cell;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.organization.HpAwardHistoryService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.excel.ExcelReadComponent;
import com.google.common.base.Objects;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;

@Controller
@RequestMapping(value = "/organization")

public class HpAwardHistoryController {
	private static final Logger LOGGER = LoggerFactory.getLogger(HpAwardHistoryController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

    @Autowired
    private CsvReadComponent csvReadComponent;

	@Autowired
	private HpAwardHistoryService hpAwardHistoryService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@RequestMapping(value="hpAwardHistory.do")
	public String hpAwardHistory(ModelMap model, SessionVO sessionVO) throws Exception{
		return "organization/organization/hpAwardHistory/hpAwardHistory";
	}

	@RequestMapping(value="hpAwardHistoryNewUpload.do")
	public String hpAwardHistoryNewUpload(ModelMap model, SessionVO sessionVO) throws Exception{
		return "organization/organization/hpAwardHistory/newUpload";
	}

	@RequestMapping(value="hpAwardHistoryConfigureIncentive.do")
	public String hpAwardHistoryConfigureIncentive(ModelMap model, SessionVO sessionVO) throws Exception{
		return "organization/organization/hpAwardHistory/incentiveCode";
	}

	@RequestMapping(value="hpAwardHistoryDetails.do")
	public String hpAwardHistoryDetails(ModelMap model, SessionVO sessionVO, @RequestParam Map<String, Object> params) throws Exception{
		model.put("viewData", new Gson().toJson(hpAwardHistoryService.selectHpAwardHistoryDetails(params)));
		return "organization/organization/hpAwardHistory/viewDetails";
	}

	@RequestMapping(value="hpAwardHistoryConfirmDetails.do")
	public String hpAwardHistoryConfirmDetails(ModelMap model, SessionVO sessionVO, @RequestParam Map<String, Object> params) throws Exception{
		model.put("verifyData", new Gson().toJson(hpAwardHistoryService.selectHpAwardHistoryDetails(params)));
		return "organization/organization/hpAwardHistory/confirmDetails";
	}

	@RequestMapping(value="selectHpAwardHistoryListing.do")
	public ResponseEntity<List<EgovMap>>selectHpAwardHistoryListing(SessionVO sessionVO, @RequestParam Map<String, Object> params){
		return ResponseEntity.ok(hpAwardHistoryService.selectHpAwardHistoryListing(params));
	}

	@RequestMapping(value="selectEachHpAwardHistory.do")
	public ResponseEntity<List<EgovMap>>selectEachHpAwardHistory(SessionVO sessionVO, @RequestParam Map<String, Object> params){
		return ResponseEntity.ok(hpAwardHistoryService.selectEachHpAwardHistory(params));
	}

	@RequestMapping(value="selectIncentiveCode.do")
	public ResponseEntity<List<EgovMap>>selectIncentiveCode(SessionVO sessionVO, @RequestParam Map<String, Object> params){
		return ResponseEntity.ok(hpAwardHistoryService.selectIncentiveCode(params));
	}

	@Transactional
	@RequestMapping(value="submitHpAwardHistory.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> submitHpAwardHistory(MultipartHttpServletRequest request, SessionVO sessionVO) throws InvalidFormatException, IOException{
		Map<String, Object> response = new HashMap<String, Object>();

		try{
			List<Map<String, String>> result = csvReadComponent.readCsvToList(request.getFile("newUpload"), false, r -> {
				Map<String, String> result2 = new HashMap<String, String>();
				result2.put("incentiveCode", r.get(0).trim());
				result2.put("hpCode", r.get(1).trim());
				result2.put("destination", r.get(2).trim());
				result2.put("remark", r.get(3).trim());
				result2.put("month", r.get(4).trim());
				result2.put("year", r.get(5).trim());
				return result2;
			});

			Map<String, Object> x = new HashMap<String, Object>();
			x.put("incentiveCode", "Incentive Code");
			x.put("hpCode", "HP Code");
			x.put("destination", "Destination");
			x.put("remark", "Remark");
			x.put("month", "Month");
			x.put("year", "Year");
			if (!Objects.equal(result.get(0).toString(),  x.toString())){
				response.put("success", 0);
				response.put("msg", messageAccessor.getMessage("hpawardFormat.incorrect"));
				return ResponseEntity.ok(response);
			}

			List<Map<String, Object>> csvData = result.subList(1, result.size()).stream().filter(r-> r.get("incentiveCode")!=null && r.get("hpCode")!=null).map(r->{
				Map<String, Object> csvRes = new HashMap<String, Object> ();
				csvRes.put("incentiveCode", r.get("incentiveCode").toString().trim());
				csvRes.put("hpCode", r.get("hpCode").toString().trim());
				csvRes.put("destination", r.get("destination").toString().trim());
				csvRes.put("remark", r.get("remark").toString().trim());
				csvRes.put("month", Integer.parseInt(r.get("month").toString().trim()));
				csvRes.put("year", Integer.parseInt(r.get("year").toString().trim()));
				return csvRes;
			}).collect(Collectors.toList());


			if(csvData.size()>0){
				Map <String, Object> param = new HashMap<String, Object>();
				param.put("userId", sessionVO.getUserId());

				int masterResult = 0 , detailsResult= 0;
				masterResult = hpAwardHistoryService.insertHpAwardHistoryMaster(param);

				for(Map<String, Object> details : csvData){
					details.put("userId", sessionVO.getUserId());
					detailsResult = hpAwardHistoryService.insertHpAwardHistoryDetails(details);
				}

				response.put("success", masterResult > 0 && detailsResult > 0 ? 1:0);
				response.put("msg", masterResult > 0 && detailsResult > 0 ? messageAccessor.getMessage("hpawardUpload.success") : messageAccessor.getMessage("hpawardUpload.fail"));
				return ResponseEntity.ok(response);

			}else{
				response.put("success", 0);
				response.put("msg", messageAccessor.getMessage("hpawardUpload.noData"));
				return ResponseEntity.ok(response);
			}

		}catch(Exception e){
			response.put("success", 0);
			response.put("msg", messageAccessor.getMessage("hpawardFormat.incorrect"));
			return ResponseEntity.ok(response);
		}
	}


	@Transactional
	@RequestMapping(value = "/updateHpAwardHistoryStatus.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> updateHpAwardHistoryStatus(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		params.put("userId", sessionVO.getUserId());
		Map<String, Object> response = new HashMap<String, Object>();

		int updateBatch = hpAwardHistoryService.updateHpAwardHistoryStatus(params);
		response.put("success", updateBatch > 0 ? 1 : 0);

		if(params.get("type").toString().equals("deactivate")){
			response.put("msg", updateBatch > 0 ? messageAccessor.getMessage("hpawardDeactivate.success") : messageAccessor.getMessage("hpawardDeactivate.fail"));
		}else if(params.get("type").toString().equals("approve")){
			response.put("msg", updateBatch > 0 ? messageAccessor.getMessage("hpawardApprove.success") : messageAccessor.getMessage("hpawardApprove.fail"));
		}else if(params.get("type").toString().equals("reject")){
			response.put("msg", updateBatch > 0 ? messageAccessor.getMessage("hpawardReject.success") : messageAccessor.getMessage("hpawardReject.fail"));
		}
		return ResponseEntity.ok(response);
	}

	@Transactional
	@RequestMapping(value = "/updateHpAwardHistoryDetails.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> updateHpAwardHistoryDetails(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		List<Object> addList = (List<Object>) params.get("addList");
		List<Object> editList = (List<Object>) params.get("editList");
		int updateBatch = 1, updateAllList = 1;

		params.put("userId", sessionVO.getUserId());

		if(addList.size() > 0 || editList.size()>0){
			updateAllList = hpAwardHistoryService.updateHpAwardHistoryDetails(params);
		}

		updateBatch = hpAwardHistoryService.updateHpAwardHistoryStatus(params);

		Map<String, Object> response = new HashMap<String, Object>();
		response.put("success", updateAllList > 0 && updateBatch > 0? 1 : 0);
		return ResponseEntity.ok(response);
	}

	@Transactional
	@RequestMapping(value = "/updateIncentiveCode.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> updateIncentiveCode(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		List<Object> addList = (List<Object>) params.get("addList");
		List<Object> editList = (List<Object>) params.get("editList");
		List<Object> removeList = (List<Object>) params.get("removeList");
		Map<String, Object> updateAllList = new HashMap<String, Object>() ;

		params.put("userId", sessionVO.getUserId());

		if(addList.size() > 0 || editList.size()>0 || removeList.size()>0){
			updateAllList = hpAwardHistoryService.updateIncentiveCode(params);
		}

		Map<String, Object> response = new HashMap<String, Object>();
		response.put("success", updateAllList.get("success"));
		response.put("msg", updateAllList.get("msg").toString());
		return ResponseEntity.ok(response);
	}


	@RequestMapping(value="hpAwardHistoryReport.do")
	public String hpAwardHistoryReport(ModelMap model, SessionVO sessionVO, @RequestParam Map<String, Object> params) throws Exception{
		params.put("userId", sessionVO.getUserId());
		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("orgCode", getUserInfo.get("orgCode").toString().trim());
			model.put("grpCode", getUserInfo.get("grpCode").toString().trim());
			model.put("deptCode", getUserInfo.get("deptCode").toString().trim());
		}
		return "organization/organization/hpAwardHistory/hpAwardHistoryReport";
	}

	@RequestMapping(value="selectHpAwardHistoryReport.do")
	public ResponseEntity<List<EgovMap>>selectHpAwardHistoryReport(HttpServletRequest request, ModelMap model, SessionVO sessionVO, @RequestParam Map<String, Object> params){
		String[] monthList = request.getParameterValues("month");
		String[] incentiveCodeList = request.getParameterValues("incentiveType");
		params.put("monthList", monthList);
		params.put("incentiveCodeList", incentiveCodeList);
		return ResponseEntity.ok(hpAwardHistoryService.selectHpAwardHistoryReport(params));
	}

	@RequestMapping(value="selectMonthList.do")
	public ResponseEntity<List<EgovMap>>selectMonthList(SessionVO sessionVO, @RequestParam Map<String, Object> params){
		return ResponseEntity.ok(hpAwardHistoryService.selectMonthList(params));
	}

	@RequestMapping(value="selectYearList.do")
	public ResponseEntity<List<EgovMap>>selectYearList(SessionVO sessionVO, @RequestParam Map<String, Object> params){
		return ResponseEntity.ok(hpAwardHistoryService.selectYearList(params));
	}

}



