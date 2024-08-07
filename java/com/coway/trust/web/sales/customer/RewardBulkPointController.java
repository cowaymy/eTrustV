package com.coway.trust.web.sales.customer;

/**************************************
 * Author	Date				Remark
 * Kyron		2023/08/14		Create for Tier Point
 *
 ***************************************/

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.jsoup.helper.StringUtil;
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
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.sales.customer.RewardPointService;
import com.coway.trust.biz.sales.customer.RewardBulkUploadVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value="/sales/customer")
public class RewardBulkPointController {
	private static final Logger logger = LoggerFactory.getLogger(RewardBulkPointController.class);

	@Resource(name = "RewardPointService")
	private RewardPointService rewardPointService;

	@Autowired
	private CsvReadComponent csvReadComponent;

	@RequestMapping(value = "/initRewardBulkPointList.do")
	public String initASManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "sales/customer/rewardBulkPointList";
	}

	@RequestMapping(value = "/uploadRewardBulkPoint.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> uploadRewardBulkPoint(@RequestParam Map<String, Object>params, MultipartHttpServletRequest request, SessionVO sessionVO) throws Exception {
		ReturnMessage message = new ReturnMessage();

		logger.debug(" ================ csvFileUpload ===================   "  );


		//CVS 파일 세팅
		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<RewardBulkUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, true, RewardBulkUploadVO::create);

		// CVS 파일 객체 세팅
		Map<String, Object> cvsParam = new HashMap<String, Object>();
		cvsParam.put("voList", vos);
		cvsParam.put("userId", sessionVO.getUserId());

		// cvs 파일 저장 처리
		List<RewardBulkUploadVO> vos2 = (List<RewardBulkUploadVO>) cvsParam.get("voList");

		logger.debug(" ================ size ===================   " +vos2.size() );

		Map<String, Object> masterList = new HashMap<String, Object>();
		masterList.put("tierStatusID", 1);
		masterList.put("remark", params.get("remark"));
		masterList.put("creator", sessionVO.getUserId());
		masterList.put("updater", sessionVO.getUserId());
		masterList.put("totalRecord", vos2.size());


		List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
		for (RewardBulkUploadVO vo : vos2) {

			HashMap<String, Object> map = new HashMap<String, Object>();

			map.put("custNRIC", vo.getCustNRIC());
			map.put("rewardType", vo.getRewardType());
			map.put("remark", vo.getRemark().trim());
			map.put("rewardPoint", vo.getRewardPoint());
			map.put("stusId", 1);
			map.put("creator", sessionVO.getUserId());
			map.put("updater", sessionVO.getUserId());

			detailList.add(map);
		}

		logger.debug(" ================ detailsList ===================   " + detailList );
		logger.debug(" ================ masterList ===================   " +masterList );

		int result = rewardPointService.saveRewardBulkPointUpload(masterList, detailList);
		if (result > 0) {
		    message.setMessage("CSV Point_Batch successfully uploaded.<br />Tier Upload ID : " + result);
		} else {
		    message.setMessage("Failed to upload CSV Point_Batch. Please try again later.");
		}
		return ResponseEntity.ok(message);
    }

	@RequestMapping(value = "/selectRewardBulkPointList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectRewardBulkPointList(@RequestParam Map<String, Object> params,HttpServletRequest request, Model model) {
		String[] searchPointStatus = request.getParameterValues("searchPointStatus");
		params.put("searchPointStatus", searchPointStatus);

		List<EgovMap> list = rewardPointService.selectRewardBulkPointList(params);

		logger.debug(" ================ selectRewardBulkPointList ===================   " +list );

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectRewardBulkPointItem.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectRewardBulkPointItem(@RequestParam Map<String, Object> params,HttpServletRequest request, Model model) {

		List<EgovMap> mst = rewardPointService.selectRewardBulkPointList(params);

		List<EgovMap> details = rewardPointService.selectRewardBulkPointItem(params);

		Map<String, Object> map = new HashMap();
		map.put("mst", mst.get(0));
		map.put("details", details);
		logger.debug(" ================ Item map ===================   " +map );
		logger.debug(" ================ Item detail ===================   " +details );

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/approvalRewardBulkPoint.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> approvalRewardBulkPoint(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		String[] arrTierUploadId   = request.getParameterValues("tierUploadId");
		String status = "";

		Map<String, Object> map = new HashMap<>();

        int userId = sessionVO.getUserId();
        params.put("userId", userId);

        if(arrTierUploadId != null && !CommonUtils.containsEmpty(arrTierUploadId)){
        	params.put("tierUploadId", arrTierUploadId);
        }

        if(params.get("status").toString().equals("approve")) {
        	params.put("status", 5);
        	status = "approved";
        }
        else {
        	params.put("status", 6);
        	status = "rejected";
        	params.put("reason", params.get("reason").toString().trim());
        }

        int result = rewardPointService.approvalRewardBulkPoint(params);

//	    logger.debug(" ================ params ===================   " + arrTierUploadId);

	    ReturnMessage message = new ReturnMessage();
	    if(result > 0){
			message.setMessage("Reward bulk point has been " + status + ".");
		}else{
			message.setMessage("Failed to " + params.get("status").toString() + " this reward bulk point. Please try again later.");
		}
	    map.put("message", message);
	    return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/rejectMsgPop.do")
	public String rejectMsgPop(ModelMap model) {
		return "sales/customer/rejectionOfRewardBulkPointMsgPop";
	}
}
