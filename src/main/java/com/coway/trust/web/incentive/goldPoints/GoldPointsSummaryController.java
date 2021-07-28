package com.coway.trust.web.incentive.goldPoints;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.incentive.goldPoints.GoldPointsService;
import com.coway.trust.biz.incentive.goldPoints.GoldPointsVO;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/incentive/goldPoints")
public class GoldPointsSummaryController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GoldPointsSummaryController.class);

	@Resource(name = "memberListService")
	private MemberListService memberListService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "goldPointsService")
	private GoldPointsService goldPointsService;

	@Value("${web.resource.upload.file")
	private String uploadDir;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private CsvReadComponent csvReadComponent;

	@RequestMapping(value = "/pointsSummaryList.do")
	public String pointsSummaryList(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.info("===== pointsSummaryList.do =====");

		params.put("groupCode",1);

		List<EgovMap> memberType = commonService.selectCodeList(params);
		List<EgovMap> status = memberListService.selectStatus();

		model.addAttribute("memberType", memberType);
		model.addAttribute("status", status);

		return "incentive/goldPoints/pointsSummaryList";
	}

	@RequestMapping(value = "/uploadPointsPop.do")
	public String uploadPointsPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "incentive/goldPoints/uploadPointsPop";
	}

	@RequestMapping(value = "/csvUploadPoints.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> csvUploadPoints(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<GoldPointsVO> vos = csvReadComponent.readCsvToList(multipartFile, true, GoldPointsVO::create);

		List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();

		for (GoldPointsVO vo : vos) {

			HashMap<String, Object> hm = new HashMap<String, Object>();

	        hm.put("memCode", vo.getMemCode());
	        hm.put("memName", vo.getMemName());
	        hm.put("ptsDesc", vo.getPtsDesc());
	        hm.put("ptsEarned", vo.getPtsEarned());
	        hm.put("startDate", vo.getStartDate());
	        hm.put("endDate", vo.getEndDate());
			hm.put("crtUserId", sessionVO.getUserId());
			hm.put("updUserId", sessionVO.getUserId());

			detailList.add(hm);
		}

		Map<String, Object> master = new HashMap<String, Object>();

	    master.put("crtUserId", sessionVO.getUserId());
	    master.put("updUserId", sessionVO.getUserId());

	    int result = goldPointsService.saveCsvUpload(master, detailList);

	    ReturnMessage message = new ReturnMessage();

	    if (result > 0) {
	    	message.setMessage("Gold Points successfully uploaded.");
	        message.setCode(AppConstants.SUCCESS);
	    } else {
	    	message.setMessage("Failed to upload Gold Points. Please try again later.");
	        message.setCode(AppConstants.FAIL);
	    }

	    return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/searchPointsSummary.do")
	public ResponseEntity<List<EgovMap>> searchPointsSummary(@RequestParam Map<String, Object> params) {
		List<EgovMap> pointsSummaryList = goldPointsService.selectPointsSummaryList(params);
		return ResponseEntity.ok(pointsSummaryList);
	}

	@RequestMapping(value = "/viewPointsDetailPop.do")
	public String viewPointsDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> ptsExpiryList = goldPointsService.selectPointsExpiryList(params);
		EgovMap trxHistory = goldPointsService.selectTransactionHistory(params);
		model.put("ptsExpiryList", new Gson().toJson(ptsExpiryList));
		model.put("trxHistory", trxHistory);

		return "incentive/goldPoints/pointsDetailPop";
	}

}
