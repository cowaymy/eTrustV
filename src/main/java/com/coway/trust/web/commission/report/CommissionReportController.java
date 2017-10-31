/**
 * 
 */
package com.coway.trust.web.commission.report;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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

import com.coway.trust.biz.commission.report.CommissionReportService;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.commission.CommissionConstants;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/commission/report")
public class CommissionReportController {

	private static final Logger logger = LoggerFactory.getLogger(CommissionReportController.class);

	@Resource(name = "commissionReportService")
	private CommissionReportService commissionReportService;
	
	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	/**
	 * Call Cody commission report 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/commissionCDReport.do")
	public String commissionCDReport(@RequestParam Map<String, Object> params, ModelMap model) {
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);	
		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);
		
		model.addAttribute("memberType", CommissionConstants.COMIS_CD_GRCD);
		model.addAttribute("today", today);
		model.addAttribute("cmmDt", dt);
		// 호출될 화면
		return "commission/commissionCDReport";
	}
	
	/**
	 * Call HP commission report 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/commissionHPReport.do")
	public String commissionHPReport(@RequestParam Map<String, Object> params, ModelMap model) {
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);	
		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);
		
		model.addAttribute("memberType", CommissionConstants.COMIS_HP_GRCD);
		model.addAttribute("today", today);
		model.addAttribute("cmmDt", dt);
		// 호출될 화면
		return "commission/commissionHPReport";
	}
	
	/**
	 * Call CT commission report 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/commissionCTReport.do")
	public String commissionCTReport(@RequestParam Map<String, Object> params, ModelMap model) {
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);	
		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);
		
		model.addAttribute("memberType", CommissionConstants.COMIS_CT_GRCD);
		model.addAttribute("today", today);
		model.addAttribute("cmmDt", dt);
		// 호출될 화면
		return "commission/commissionCTReport";
	}
	
	/**
	 * select member count
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMemberCount", method = RequestMethod.GET)
	public ResponseEntity<Integer> selectCalculationList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
				
		// 조회.		
		int cnt = commissionReportService.selectMemberCount(params);

		// 데이터 리턴.
		return ResponseEntity.ok(cnt);
	}
}
