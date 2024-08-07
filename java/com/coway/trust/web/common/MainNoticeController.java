package com.coway.trust.web.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.MainNoticeService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class MainNoticeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MainNoticeController.class);

	@Autowired
	private MainNoticeService mainNoticeService;

	@Resource(name = "webInvoiceService")
    private WebInvoiceService webInvoiceService;

	@RequestMapping(value = "/selectDailyCount.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDailyCount(@RequestParam Map<String, Object> params, SessionVO sessionVO) {

	    String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));

	    if(!CommonUtils.containsEmpty(memCode)) {
	        params.put("memCode", memCode);
	        EgovMap apprDtls = new EgovMap();
	        apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);

	        if(apprDtls != null) {
	            params.put("apprGrp", 1);
	        }
	    }

	    params.put("userId", sessionVO.getUserName());

		List<EgovMap> selectDailyCountList = mainNoticeService.selectDailyCount(params);

		LOGGER.debug("return_Values: " + selectDailyCountList.toString());

		return ResponseEntity.ok(selectDailyCountList);
	}

	@RequestMapping(value = "/removeCache.do", method = RequestMethod.DELETE)
	public ResponseEntity removeCache(@RequestParam Map<String, Object> params) {
		mainNoticeService.removeCache();
		return ResponseEntity.ok(HttpStatus.OK);
	}

	@RequestMapping(value = "/getMainNotice.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getMainNotice(@RequestParam Map<String, Object> params) {
		List<EgovMap> notice = mainNoticeService.getMainNotice(params);
		return ResponseEntity.ok(notice);
	}

	@RequestMapping(value = "/getTagStatus.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getTagStatus(@RequestParam Map<String, Object> params) {
		List<EgovMap> notice = mainNoticeService.getTagStatus(params);
		return ResponseEntity.ok(notice);
	}

	@RequestMapping(value = "/openTagStatusPopup.do")
	public String openTagStatusPopup(@RequestParam Map<String, Object> params, SessionVO sessionVO,ModelMap model) {
		return "common/mainTagStatusPop";
	}

	@RequestMapping(value = "/getDailyPerformance.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getDailyPerformance(@RequestParam Map<String, Object> params) {
		List<EgovMap> notice = mainNoticeService.getDailyPerformance(params);
		return ResponseEntity.ok(notice);
	}

	@RequestMapping(value = "/getSalesOrgPerf.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getSalesOrgPerf(@RequestParam Map<String, Object> params, SessionVO sessionVO) {
        params.put("memId", sessionVO.getMemId());
        List<EgovMap> notice = mainNoticeService.getSalesOrgPerf(params);
        return ResponseEntity.ok(notice);
    }

	@RequestMapping(value = "/getCustomerBday.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getCustomerBday(@RequestParam Map<String, Object> params, SessionVO sessionVO) {
        params.put("userId", sessionVO.getUserId());
        List<EgovMap> notice = mainNoticeService.getCustomerBday(params);
        return ResponseEntity.ok(notice);
    }

	 @RequestMapping(value = "/getAccRewardPoints.do", method = RequestMethod.GET)
   public ResponseEntity<List<EgovMap>> getAccRewardPoints(@RequestParam Map<String, Object> params) {
       List<EgovMap> list = mainNoticeService.getAccRewardPoints(params);
       return ResponseEntity.ok(list);
   }

	 @RequestMapping(value = "/getHPBirthday.do", method = RequestMethod.GET)
	 public ResponseEntity<List<EgovMap>> getHPBirthday(@RequestParam Map<String, Object> params, SessionVO sessionVO) {
	        params.put("userId", sessionVO.getUserId());
	        List<EgovMap> hpBdayList = mainNoticeService.getHPBirthday(params);
	        return ResponseEntity.ok(hpBdayList);
	}
}
