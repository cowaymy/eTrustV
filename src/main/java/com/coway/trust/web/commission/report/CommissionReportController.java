/**
 *
 */
package com.coway.trust.web.commission.report;

import java.io.File;
import java.io.FileFilter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

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

import com.a.a.a.g.m.l;
import com.coway.trust.biz.commission.report.CommissionReportService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.commission.CommissionConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

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

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@Value("${web.resource.upload.file}")
	private String uploadDirWeb;

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
	public String commissionCDReport(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);
		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);
		String loginId = String.valueOf(sessionVO.getUserName());	//member code

		model.addAttribute("memberType", CommissionConstants.COMIS_CD_GRCD);
		model.addAttribute("today", today);
		model.addAttribute("cmmDt", dt);
		model.addAttribute("loginId",loginId);

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
	public String commissionHPReport(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);
		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);
		String loginId = String.valueOf(sessionVO.getUserName());	//member code

		model.addAttribute("memberType", CommissionConstants.COMIS_HP_GRCD);
		model.addAttribute("today", today);
		model.addAttribute("cmmDt", dt);
		model.addAttribute("loginId",loginId);

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
	public String commissionCTReport(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);
		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);
		String loginId = String.valueOf(sessionVO.getUserName());	//member code

		model.addAttribute("memberType", CommissionConstants.COMIS_CT_GRCD);
		model.addAttribute("today", today);
		model.addAttribute("cmmDt", dt);
		model.addAttribute("loginId",loginId);

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
	public ResponseEntity<Map> selectCalculationList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {

		// 조회.
		//int cnt = commissionReportService.selectMemberCount(params);
		EgovMap map = commissionReportService.selectMemberCount(params);

		// 데이터 리턴.
		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/commSHIIndexView.do")
	public String commSHICollection(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		String dt = CommonUtils.getCalMonth(0);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);
		String loginId = String.valueOf(sessionVO.getUserName());	//member code

		List memType = commissionReportService.commissionGroupType(params);
		model.addAttribute("memType", memType);
		model.addAttribute("today", today);
		model.addAttribute("searchDt", dt);
		model.addAttribute("loginId",loginId);

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
		  params.put("typeCode",sessionVO.getUserTypeId());
		  //params.put("memCode", sessionVO.getUserMemCode());
		  params.put("memCode", loginId); //ticket #24032866
		  params.put("pvMonth", today.substring(2,4));
		  params.put("pvYear", today.substring(4));

      Map getUserInfo =commissionReportService.commSHIMemberSearch(params);

      model.put("memCodeType", sessionVO.getUserTypeId() );
      model.put("orgCode", getUserInfo.get("ORG_CODE"));
      model.put("grpCode", getUserInfo.get("GRP_CODE"));
      model.put("deptCode", getUserInfo.get("DEPT_CODE"));
      model.put("memCode", getUserInfo.get("MEM_CODE"));
		}

		// 호출될 화면
		return "commission/commissionSHICollectionTarget";
	}

	@RequestMapping(value = "commSHIMemSearch")
	public ResponseEntity<Map> commSHIMemSearch(@RequestParam Map<String, Object> params, ModelMap model) {
		String date = params.get("shiDate").toString();
		String pvMonth =date.substring(0,2);
		String pvYear=date.substring(date.indexOf("/")+1,date.length());
		params.put("pvMonth",pvMonth);
		params.put("pvYear",pvYear);

		Map detail =commissionReportService.commSHIMemberSearch(params);
		System.out.println(detail);
		return ResponseEntity.ok(detail);
	}

	@RequestMapping(value = "commSPCRgenrawSHIIndex_BK")
	public ResponseEntity<List> commSPCRgenrawSHIIndex_BK(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

	    logger.debug("params =====================================>>  " + params);

		String date = params.get("shiDate").toString();
		String pvMonth =date.substring(0,2);
		String pvYear=date.substring(date.indexOf("/")+1,date.length());
		params.put("pvMonth",pvMonth);
		params.put("pvYear",pvYear);

		// 2019-07-16 - LaiKW - Added customer type
		String custType = params.get("custType").toString();
		if(Integer.parseInt(params.get("custType").toString()) == 1) {
		    custType = "'964','965'";
		} else {
		    custType = "'" + custType + "'";
		}
		params.put("custType", custType);

		String catType = params.get("catType").toString();
		params.put("catType", catType);

		commissionReportService.commSPCRgenrawSHIIndexCall(params);

		List<EgovMap> list = (List<EgovMap>)params.get("cv_1");
		/*logger.debug("################################");
		System.out.println(list);
		logger.debug("################################");*/

		DecimalFormat df = new DecimalFormat("##.00");

		String sTOPORGCODE = "";
		String sORGCODE = "";
		String sGRPCODE = "";
		String sDEPTCODE = "";
		String sHPCODE = "";

        int sTOPOUNIT = 0;
        double sTOPOCOLLECTTARGET = 0;
        double sTOPOCOLLECT_AMT = 0;
        double sTOPOOUTSTDTRATE = 0;

        int sOUNIT = 0;
        double sOCOLLECTTARGET = 0;
        double sOCOLLECT_AMT = 0;
        double sOOUTSTDTRATE = 0;

        int sGUNIT = 0;
        double sGCOLLECTTARGET = 0;
        double sGCOLLECT_AMT = 0;
        double sGOUTSTDTRATE = 0;

        int sDUNIT = 0;
        double sDCOLLECTTARGET = 0;
        double sDCOLLECT_AMT = 0;
        double sDOUTSTDTRATE = 0;

        Boolean bRecordExist = false;

        List<EgovMap> tempList = null;
        List finalList = new ArrayList();
        EgovMap finalMap =new EgovMap();

		for(int i=0; i< list.size(); i++){

			if ( !( sDEPTCODE.equals(list.get(i).get("deptCode").toString()) ) && sDUNIT > 0){
				finalMap = new EgovMap();
				finalMap.put("topOrgCode","");
				finalMap.put("orgCode","");
				finalMap.put("grpCode","");
				finalMap.put("deptCode",sDEPTCODE);
				finalMap.put("memCode","");
				finalMap.put("unit",sDUNIT);
				finalMap.put("targetatmt",df.format(sDCOLLECTTARGET));
				finalMap.put("collectamt",df.format(sDCOLLECT_AMT));
				finalMap.put("collectrate",sDCOLLECTTARGET > 0 ? df.format(100 *(sDCOLLECT_AMT / sDCOLLECTTARGET)) : df.format(0));
				finalList.add(finalMap);

				if ( !( sGRPCODE.equals(list.get(i).get("grpCode").toString()) ) && sGUNIT > 0){
					finalMap = new EgovMap();
					finalMap.put("topOrgCode","");
					finalMap.put("orgCode","");
					finalMap.put("grpCode",sGRPCODE);
					finalMap.put("deptCode","");
					finalMap.put("memCode","");
					finalMap.put("unit",sGUNIT);
					finalMap.put("targetatmt",df.format(sGCOLLECTTARGET));
					finalMap.put("collectamt",df.format(sGCOLLECT_AMT));
					finalMap.put("collectrate",sGCOLLECTTARGET > 0 ? df.format((100 * (sGCOLLECT_AMT / sGCOLLECTTARGET))) : df.format(0));
					finalList.add(finalMap);

					if( !( sORGCODE.equals(list.get(i).get("orgCode").toString()) ) && sOUNIT > 0){
						finalMap = new EgovMap();
						finalMap.put("topOrgCode","");
						finalMap.put("orgCode",sORGCODE);
						finalMap.put("grpCode","");
						finalMap.put("deptCode","");
						finalMap.put("memCode","");
						finalMap.put("unit",sOUNIT);
						finalMap.put("targetatmt",df.format(sOCOLLECTTARGET));
						finalMap.put("collectamt",df.format(sOCOLLECT_AMT));
						finalMap.put("collectrate",sOCOLLECTTARGET > 0 ? df.format((100 *(sOCOLLECT_AMT / sOCOLLECTTARGET))) : df.format(0));
						finalList.add(finalMap);

						sTOPORGCODE = list.get(i).get("topOrgCode").toString();
                        sORGCODE =list.get(i).get("orgCode").toString();
                        sGRPCODE= list.get(i).get("grpCode").toString();
                        sDEPTCODE= list.get(i).get("deptCode").toString();
                        sHPCODE = list.get(i).get("memCode").toString();
                        sOUNIT = 0;
                        sOCOLLECTTARGET = 0;
                        sOCOLLECT_AMT = 0;
                        sOOUTSTDTRATE = 0;
					}//orgCode

					if ( !( sTOPORGCODE.equals(list.get(i).get("topOrgCode").toString()) ) && sTOPOUNIT > 0){
						finalMap = new EgovMap();
						finalMap.put("topOrgCode",sTOPORGCODE);
						finalMap.put("orgCode","");
						finalMap.put("grpCode","");
						finalMap.put("deptCode","");
						finalMap.put("memCode","");
						finalMap.put("unit",sTOPOUNIT);
						finalMap.put("targetatmt",df.format(sTOPOCOLLECTTARGET));
						finalMap.put("collectamt",df.format(sTOPOCOLLECT_AMT));
						finalMap.put("collectrate",sTOPOCOLLECTTARGET > 0 ? df.format((100 *(sTOPOCOLLECT_AMT / sTOPOCOLLECTTARGET))) : df.format(0));
						finalList.add(finalMap);

						sTOPORGCODE = list.get(i).get("topOrgCode").toString();
                        sORGCODE = list.get(i).get("orgCode").toString();
                        sGRPCODE = list.get(i).get("grpCode").toString();
                        sDEPTCODE = list.get(i).get("deptCode").toString();
                        sHPCODE = list.get(i).get("memCode").toString();
                        sTOPOUNIT = 0;
                        sTOPOCOLLECTTARGET = 0;
                        sTOPOCOLLECT_AMT = 0;
                        sTOPOOUTSTDTRATE = 0;
					}//topOrgCode

					sTOPORGCODE = list.get(i).get("topOrgCode").toString();
                    sORGCODE = list.get(i).get("orgCode").toString();
                    sGRPCODE = list.get(i).get("grpCode").toString();
                    sDEPTCODE = list.get(i).get("deptCode").toString();
                    sHPCODE = list.get(i).get("memCode").toString();
                    sGUNIT = 0;
                    sGCOLLECTTARGET = 0;
                    sGCOLLECT_AMT = 0;
                    sGOUTSTDTRATE = 0;
				}//grpCode

				sTOPORGCODE = list.get(i).get("topOrgCode").toString();
                sORGCODE = list.get(i).get("orgCode").toString();
                sGRPCODE = list.get(i).get("grpCode").toString();
                sDEPTCODE = list.get(i).get("deptCode").toString();
                sHPCODE = list.get(i).get("memCode").toString();
                sGUNIT = 0;
                sGCOLLECTTARGET = 0;
                sGCOLLECT_AMT = 0;
                sGOUTSTDTRATE = 0;
			}//deptCode

			if(list.get(i).get("memCode") != null && !"".equals(list.get(i).get("memCode").toString())){
				finalMap = new EgovMap();
				finalMap.put("topOrgCode","");
				finalMap.put("orgCode","");
				finalMap.put("grpCode","");
				finalMap.put("deptCode","");
				finalMap.put("memCode",list.get(i).get("memCode"));
				finalMap.put("unit",list.get(i).get("unit"));
				finalMap.put("targetatmt",df.format(list.get(i).get("targetatmt")));
				finalMap.put("collectamt",df.format(list.get(i).get("collectamt")));
				Double targetatmt = list.get(i).get("targetatmt") != null ? Double.parseDouble(list.get(i).get("targetatmt").toString()) : 0;
				Double collectamt = list.get(i).get("collectamt") != null ? Double.parseDouble(list.get(i).get("collectamt").toString()) : 0;
				finalMap.put("collectrate",targetatmt > 0 ? df.format((100 *( collectamt / targetatmt ))) : df.format(0));
				finalList.add(finalMap);
			}
			sTOPORGCODE = list.get(i).get("topOrgCode").toString();
            sORGCODE = list.get(i).get("orgCode").toString();
            sGRPCODE = list.get(i).get("grpCode").toString();
            sDEPTCODE = list.get(i).get("deptCode").toString();
            sHPCODE = list.get(i).get("memCode").toString();
            sDUNIT = list.get(i).get("unit") !=null?  sDUNIT + Integer.parseInt(list.get(i).get("unit").toString()) :sDUNIT + 0;
            sDCOLLECTTARGET = list.get(i).get("targetatmt") != null ? sDCOLLECTTARGET + Double.parseDouble(list.get(i).get("targetatmt").toString()) : sDCOLLECTTARGET + 0;
            sDCOLLECT_AMT = list.get(i).get("collectamt") != null ? sDCOLLECT_AMT + Double.parseDouble(list.get(i).get("collectamt").toString()) : sDCOLLECT_AMT + 0;

            if (sDCOLLECTTARGET != 0)
                sDOUTSTDTRATE = (sDCOLLECT_AMT / sDCOLLECTTARGET);
            else
                sDOUTSTDTRATE = 0;

			sTOPORGCODE = list.get(i).get("topOrgCode").toString();
            sORGCODE = list.get(i).get("orgCode").toString();
            sGRPCODE = list.get(i).get("grpCode").toString();
            sDEPTCODE = list.get(i).get("deptCode").toString();
            sHPCODE = list.get(i).get("memCode").toString();
            sGUNIT = list.get(i).get("unit") != null ? sGUNIT + Integer.parseInt(list.get(i).get("unit").toString()) : sGUNIT + 0;
            sGCOLLECTTARGET = list.get(i).get("targetatmt") != null ? sGCOLLECTTARGET + Double.parseDouble(list.get(i).get("targetatmt").toString()) : sGCOLLECTTARGET + 0;
            sGCOLLECT_AMT = list.get(i).get("collectamt") != null ? sGCOLLECT_AMT + Double.parseDouble(list.get(i).get("collectamt").toString()) : sGCOLLECT_AMT + 0;

            if (sGCOLLECTTARGET != 0)
                sGOUTSTDTRATE = (sGCOLLECT_AMT / sGCOLLECTTARGET);
            else
                sGOUTSTDTRATE = 0;

            sTOPORGCODE = list.get(i).get("topOrgCode").toString();
            sORGCODE = list.get(i).get("orgCode").toString();
            sGRPCODE = list.get(i).get("grpCode").toString();
            sDEPTCODE = list.get(i).get("deptCode").toString();
            sHPCODE = list.get(i).get("memCode").toString();
            sOUNIT = list.get(i).get("unit") != null ? sOUNIT + Integer.parseInt(list.get(i).get("unit").toString()) : sOUNIT + 0;
            sOCOLLECTTARGET = list.get(i).get("targetatmt") != null ? sOCOLLECTTARGET + Double.parseDouble(list.get(i).get("targetatmt").toString()) : sOCOLLECTTARGET + 0;
            sOCOLLECT_AMT = list.get(i).get("collectamt") != null ? sOCOLLECT_AMT + Double.parseDouble(list.get(i).get("collectamt").toString()) : sOCOLLECT_AMT + 0;

            if (sOCOLLECTTARGET != 0)
                sOOUTSTDTRATE = (sOCOLLECT_AMT / sOCOLLECTTARGET);
            else
                sOOUTSTDTRATE = 0;

            sTOPORGCODE = list.get(i).get("topOrgCode").toString();
            sORGCODE = list.get(i).get("orgCode").toString();
            sGRPCODE = list.get(i).get("grpCode").toString();
            sDEPTCODE = list.get(i).get("deptCode").toString();
            sHPCODE = list.get(i).get("memCode").toString();
            sTOPOUNIT = list.get(i).get("unit") != null ? sTOPOUNIT + Integer.parseInt(list.get(i).get("unit").toString()) : sTOPOUNIT + 0;
            sTOPOCOLLECTTARGET = list.get(i).get("targetatmt") != null ? sTOPOCOLLECTTARGET + Double.parseDouble(list.get(i).get("targetatmt").toString()) : sTOPOCOLLECTTARGET + 0;
            sTOPOCOLLECT_AMT = list.get(i).get("collectamt") != null ? sTOPOCOLLECT_AMT + Double.parseDouble(list.get(i).get("collectamt").toString()) : sTOPOCOLLECT_AMT + 0;

            if (sOCOLLECTTARGET != 0)
                sTOPOOUTSTDTRATE = (sTOPOCOLLECT_AMT / sTOPOCOLLECTTARGET);
            else
                sTOPOOUTSTDTRATE = 0;

            bRecordExist = true;

		}//for i

		if (bRecordExist){
			finalMap = new EgovMap();
			finalMap.put("topOrgCode","");
			finalMap.put("orgCode","");
			finalMap.put("grpCode","");
			finalMap.put("deptCode",sDEPTCODE);
			finalMap.put("memCode","");
			finalMap.put("unit",sDUNIT);
			finalMap.put("targetatmt",df.format(sDCOLLECTTARGET));
			finalMap.put("collectamt",df.format(sDCOLLECT_AMT));
			finalMap.put("collectrate",sDCOLLECTTARGET != 0 ? df.format((100 * (sDCOLLECT_AMT / sDCOLLECTTARGET))) : df.format(0));
			finalList.add(finalMap);


			finalMap = new EgovMap();
			finalMap.put("topOrgCode","");
			finalMap.put("orgCode","");
			finalMap.put("grpCode",sGRPCODE);
			finalMap.put("deptCode","");
			finalMap.put("memCode","");
			finalMap.put("unit",sGUNIT);
			finalMap.put("targetatmt",df.format(sGCOLLECTTARGET));
			finalMap.put("collectamt",df.format(sGCOLLECT_AMT));
			finalMap.put("collectrate",sGCOLLECTTARGET != 0 ? df.format((100 * (sGCOLLECT_AMT / sGCOLLECTTARGET))) : df.format(0));
			finalList.add(finalMap);


			finalMap = new EgovMap();
			finalMap.put("topOrgCode","");
			finalMap.put("orgCode",sORGCODE);
			finalMap.put("grpCode","");
			finalMap.put("deptCode","");
			finalMap.put("memCode","");
			finalMap.put("unit",sOUNIT);
			finalMap.put("targetatmt",df.format(sOCOLLECTTARGET));
			finalMap.put("collectamt",df.format(sOCOLLECT_AMT));
			finalMap.put("collectrate",sOCOLLECTTARGET != 0 ? df.format((100 * (sOCOLLECT_AMT / sOCOLLECTTARGET))) : df.format(0));
			finalList.add(finalMap);


			finalMap = new EgovMap();
			finalMap.put("topOrgCode",sTOPORGCODE);
			finalMap.put("orgCode","");
			finalMap.put("grpCode","");
			finalMap.put("deptCode","");
			finalMap.put("memCode","");
			finalMap.put("unit",sTOPOUNIT);
			finalMap.put("targetatmt",df.format(sTOPOCOLLECTTARGET));
			finalMap.put("collectamt",df.format(sTOPOCOLLECT_AMT));
			finalMap.put("collectrate",sTOPOCOLLECTTARGET != 0 ? df.format((100 * (sTOPOCOLLECT_AMT / sTOPOCOLLECTTARGET))) : df.format(0));
			finalList.add(finalMap);
        }
		tempList=(List<EgovMap>)finalList;
		//topOrgCode=CRS0002, orgCode=CRS1012, grpCode=CRS2055, deptCode=CRS3541, memCode=545631,
		//unit=1, targetatmt=140, collectamt=0, collectrate=0
		return ResponseEntity.ok(tempList);
	}


	@RequestMapping(value = "commSPCRgenrawSHIIndex")
  public ResponseEntity<List> commSPCRgenrawSHIIndex(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

    String date = params.get("shiDate").toString();
    String pvMonth =date.substring(0,2);
    String pvYear=date.substring(date.indexOf("/")+1,date.length());
    params.put("pvMonth",pvMonth);
    params.put("pvYear",pvYear);
    params.put("custType", params.get("custType").toString());
    params.put("catType", params.get("catType").toString());

    commissionReportService.commSPCRgenrawSHIIndexCall(params);

    List<EgovMap> list =  (List<EgovMap>) params.get("cv_1");

    final BigDecimal ONE_HUNDRED = new BigDecimal(100);

    String sTOPORGCODE = "";
    String sORGCODE = "";
    String sGRPCODE = "";
    String sDEPTCODE = "";
    String sHPCODE = "";

    String nTOPORGCODE = "";
    String nORGCODE = "";
    String nGRPCODE = "";
    String nDEPTCODE = "";

    int sTOPOUNIT = 0;
    BigDecimal sTOPOCOLLECTTARGET = null;
    BigDecimal sTOPOCOLLECT_AMT = null;
    BigDecimal sTOPOOUTSTDTRATE = null;

    int sOUNIT = 0;
    BigDecimal sOCOLLECTTARGET = null;
    BigDecimal sOCOLLECT_AMT = null;
    BigDecimal sOOUTSTDTRATE = null;

    int sGUNIT = 0;
    BigDecimal sGCOLLECTTARGET = null;
    BigDecimal sGCOLLECT_AMT = null;
    BigDecimal sGOUTSTDTRATE = null;

    int sDUNIT = 0;
    BigDecimal sDCOLLECTTARGET = null;
    BigDecimal sDCOLLECT_AMT = null;
    BigDecimal sDOUTSTDTRATE = null;

    int mUNIT = 0;
    BigDecimal mCOLLECTTARGET = null;
    BigDecimal mCOLLECT_AMT = null;

    List<EgovMap> tempList = null;
    List finalList = new ArrayList();
    EgovMap topOrgCodeMap =new EgovMap();
    EgovMap orgCodeMap = new EgovMap();
    EgovMap grpCodeMap =new EgovMap();
    EgovMap deptCodeMap =new EgovMap();
    EgovMap memberMap =new EgovMap();

    List memberList = new ArrayList();

    int orgSize = 0;
    int grpSize = 0;

    int next = 0;
    boolean hasNext = true;

    for(int i = 0; i< list.size(); i++){
      next++;

      if(next == list.size())
        hasNext = false;

      memberMap =new EgovMap();

      nDEPTCODE   = hasNext ? list.get(next).get("deptCode").toString()   : null ;
      nGRPCODE    = hasNext ? list.get(next).get("grpCode").toString()    : null ;
      nORGCODE    = hasNext ? list.get(next).get("orgCode").toString()    : null ;
      nTOPORGCODE = hasNext ? list.get(next).get("topOrgCode").toString() : null ;

      sHPCODE     = list.get(i).get("memCode").toString();
      sDEPTCODE   = list.get(i).get("deptCode").toString();
      sGRPCODE    = list.get(i).get("grpCode").toString();
      sORGCODE    = list.get(i).get("orgCode").toString();
      sTOPORGCODE = list.get(i).get("topOrgCode").toString();

      mCOLLECTTARGET = new BigDecimal(list.get(i).get("targetatmt").toString());
      mCOLLECT_AMT   = new BigDecimal(list.get(i).get("collectamt").toString());
      mUNIT          = Integer.parseInt(list.get(i).get("unit").toString());
      memberMap.put("memCode",sHPCODE);
      memberMap.put("unit",mUNIT);
      memberMap.put("targetatmt",mCOLLECTTARGET);
      memberMap.put("collectamt",mCOLLECT_AMT);
      memberMap.put("collectrate", list.get(i).get("collectrate"));
      memberList.add(memberMap);

      sDCOLLECTTARGET = sDCOLLECTTARGET == null ? new BigDecimal(mCOLLECTTARGET.toString()) : sDCOLLECTTARGET.add(mCOLLECTTARGET);
      sDCOLLECT_AMT = sDCOLLECT_AMT == null ? new BigDecimal(mCOLLECT_AMT.toString()): sDCOLLECT_AMT.add(mCOLLECT_AMT);
      sDUNIT += mUNIT;

        if(!sDEPTCODE.equals(nDEPTCODE)){

          sDOUTSTDTRATE = sDCOLLECT_AMT.multiply(ONE_HUNDRED).divide(sDCOLLECTTARGET,2,RoundingMode.HALF_UP);

          deptCodeMap = new EgovMap();
          deptCodeMap.put("deptCode",sDEPTCODE);
          deptCodeMap.put("unit",sDUNIT);
          deptCodeMap.put("targetatmt",sDCOLLECTTARGET);
          deptCodeMap.put("collectamt",sDCOLLECT_AMT);
          deptCodeMap.put("collectrate",sDOUTSTDTRATE);

          sGCOLLECTTARGET = sGCOLLECTTARGET == null ? sDCOLLECTTARGET : sGCOLLECTTARGET.add(sDCOLLECTTARGET);
          sGCOLLECT_AMT   = sGCOLLECT_AMT == null   ? sDCOLLECT_AMT   : sGCOLLECT_AMT.add(sDCOLLECT_AMT);
          sGUNIT += sDUNIT;
          sGOUTSTDTRATE = sGCOLLECT_AMT.multiply(ONE_HUNDRED).divide(sGCOLLECTTARGET,2,RoundingMode.HALF_UP);

          finalList.add(deptCodeMap);
          finalList.addAll(memberList);

          memberList = new ArrayList();
          sDCOLLECTTARGET = BigDecimal.ZERO;
          sDCOLLECT_AMT = BigDecimal.ZERO;
          sDOUTSTDTRATE = BigDecimal.ZERO;
          sDUNIT = 0;
          grpSize++;
          orgSize++;
        }
        grpSize++;

        if(!sGRPCODE.equals(nGRPCODE)){
          grpCodeMap = new EgovMap();
          grpCodeMap.put("grpCode",sGRPCODE);

          grpCodeMap.put("unit",sGUNIT);
          grpCodeMap.put("targetatmt",sGCOLLECTTARGET);
          grpCodeMap.put("collectamt",sGCOLLECT_AMT);
          grpCodeMap.put("collectrate",sGOUTSTDTRATE);

          sOCOLLECTTARGET = sOCOLLECTTARGET == null ? sGCOLLECTTARGET : sOCOLLECTTARGET.add(sGCOLLECTTARGET);
          sOCOLLECT_AMT   = sOCOLLECT_AMT   == null ? sGCOLLECT_AMT   : sOCOLLECT_AMT.add(sGCOLLECT_AMT);
          sOUNIT += sGUNIT;
          sOOUTSTDTRATE = sOCOLLECT_AMT.multiply(ONE_HUNDRED).divide(sOCOLLECTTARGET,2,RoundingMode.HALF_UP);

          finalList.add(finalList.size() - grpSize,grpCodeMap);

          sGCOLLECTTARGET = BigDecimal.ZERO;
          sGCOLLECT_AMT = BigDecimal.ZERO;
          sGOUTSTDTRATE = BigDecimal.ZERO;
          sGUNIT = 0;
          grpSize = 0;
          orgSize++;
        }

        orgSize++;
        if(!sORGCODE.equals(nORGCODE)){

          orgCodeMap = new EgovMap();
          orgCodeMap.put("orgCode",sORGCODE);

          orgCodeMap.put("unit",sOUNIT);
          orgCodeMap.put("targetatmt",sOCOLLECTTARGET);
          orgCodeMap.put("collectamt",sOCOLLECT_AMT);
          orgCodeMap.put("collectrate",sOOUTSTDTRATE);

          finalList.add(finalList.size() - orgSize,orgCodeMap);

          sTOPOCOLLECTTARGET = sTOPOCOLLECTTARGET == null ? sOCOLLECTTARGET : sTOPOCOLLECTTARGET.add(sOCOLLECTTARGET);
          sTOPOCOLLECT_AMT   = sTOPOCOLLECT_AMT   == null ? sOCOLLECT_AMT   : sTOPOCOLLECT_AMT.add(sOCOLLECT_AMT);
          sTOPOUNIT += sOUNIT;
          sTOPOOUTSTDTRATE = sTOPOCOLLECT_AMT.multiply(ONE_HUNDRED).divide(sTOPOCOLLECTTARGET,2,RoundingMode.HALF_UP);

          sOCOLLECTTARGET = BigDecimal.ZERO;
          sOCOLLECT_AMT = BigDecimal.ZERO;
          sOOUTSTDTRATE = BigDecimal.ZERO;
          sOUNIT = 0;
          orgSize = 0;
        }

        if(!sTOPORGCODE.equals(nTOPORGCODE)){

          topOrgCodeMap = new EgovMap();
          topOrgCodeMap.put("topOrgCode",sTOPORGCODE);

          topOrgCodeMap.put("unit",sTOPOUNIT);
          topOrgCodeMap.put("targetatmt",sTOPOCOLLECTTARGET);
          topOrgCodeMap.put("collectamt",sTOPOCOLLECT_AMT);
          topOrgCodeMap.put("collectrate",sTOPOOUTSTDTRATE);

          finalList.add(0,topOrgCodeMap);

          sTOPOCOLLECTTARGET = BigDecimal.ZERO;
          sTOPOCOLLECT_AMT = BigDecimal.ZERO;
          sTOPOOUTSTDTRATE = BigDecimal.ZERO;
          sTOPOUNIT = 0;
        }
    }

    tempList=(List<EgovMap>)finalList;
    return ResponseEntity.ok(tempList);
  }


	@RequestMapping(value = "/commSHIIndexViewDetailsPop.do")
	public String commSHIIndexViewDetailsPop(@RequestParam Map<String, Object> params, ModelMap model) {

		String dt ="";

		if(params.get("searchDt") != null){
			dt = params.get("searchDt").toString();
		}else{
			dt = CommonUtils.getCalMonth(0);
			dt = dt.substring(4,6) + "/" + dt.substring(0, 4);
		}

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);

		model.addAttribute("today", today);
		model.addAttribute("searchDtD", dt);
		model.addAttribute("memCode", params.get("memCode"));

	  model.addAttribute("data",params);

		// 호출될 화면
		return "commission/commissionSHIIndexViewDetailPop";
	}

	@RequestMapping(value = "commSHIDetailSearch")
	public ResponseEntity<List<EgovMap>> commSHIDetailSearch(@RequestParam Map<String, Object> params, ModelMap model) {

	  System.out.println(params);

	  String date = params.get("shiDate").toString();
		String pvMonth =date.substring(0,2);
		String pvYear=date.substring(date.indexOf("/")+1,date.length());
		params.put("pvMonth",pvMonth);
		params.put("pvYear",pvYear);

		commissionReportService.commSHIIndexDetailsCall(params);
		List<EgovMap> list = (List<EgovMap>)params.get("cv_1");

		return ResponseEntity.ok(list);
	}


	/**
	 * Call Finance commission report
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/commissionFinanceReport.do")
	public String commissionFinanceReport(@RequestParam Map<String, Object> params, ModelMap model) {
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);
		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);

		//model.addAttribute("memberType", CommissionConstants.COMIS_CD_GRCD);
		model.addAttribute("today", today);
		model.addAttribute("cmmDt", dt);
		// 호출될 화면
		return "commission/commissionFinanceReport";
	}

	/**
	 * Call commissionRentalToOutrightReport commission report
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/commissionRentalToOutrightReport.do")
	public String commissionRentalToOutrightReport(@RequestParam Map<String, Object> params, ModelMap model) {
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);
		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);

		//model.addAttribute("memberType", CommissionConstants.COMIS_CD_GRCD);
		model.addAttribute("today", today);
		model.addAttribute("cmmDt", dt);
		// 호출될 화면
		return "commission/commissionRentalToOutrightReport";
	}

	/**
	 *  Organization Ajax Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectOrgCdListAll", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrgCdListAll(@RequestParam Map<String, Object> params, ModelMap model) {

		// 조회.
		if(params.get("searchDt") != null){
			String dt = String.valueOf(params.get("searchDt"));
			dt = dt.substring(dt.indexOf("/")+1,dt.length())+dt.substring(0,dt.indexOf("/"));

			params.put("searchDt", dt);
		}
		List<EgovMap> orgList = commissionReportService.selectOrgCdListAll(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orgList);
	}

	@RequestMapping(value = "/commissionCDResultIndex.do")
	public String commissionCodyResultIndex(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("mstId", CommissionConstants.COMIS_EMP_CD);
		List<EgovMap> orgGrList = commissionReportService.selectOrgGrList(params);
		params.put("mstId", CommissionConstants.COMIS_CD_CD);
		List<EgovMap> orgList = commissionReportService.selectOrgList(params);

		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);

		model.addAttribute("searchDt", dt);
		model.addAttribute("orgGrList", orgGrList);
		model.addAttribute("orgList", orgList);

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);

		model.addAttribute("today", today);

		// 호출될 화면
		return "commission/commissionCodyResultIndex";
	}

	@RequestMapping(value = "/selectCodyRawData", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCMRawData(@RequestParam Map<String, Object> params, ModelMap model) {

		String dt = String.valueOf(params.get("searchDt"));
		int pvMonth = Integer.parseInt(dt.substring(0,2));
		int pvYear = Integer.parseInt(dt.substring(3));

		int sTaskID = (((pvMonth) + (pvYear) * 12) - 24157);

		params.put("taskId", sTaskID);
		params.put("pvMonth", pvMonth);
		params.put("pvYear", pvYear);

		List<EgovMap> rawList = null;

		/**
		 * TO-DO
		 * codeid로 하고있는 것들을 code로 변경하고 쿼리고 code가져와서 분기시키기.
		 * level constants 이용하기.
		 */
		String level = "0";
		if((CommissionConstants.COMIS_CD_CDN_CD).equals(params.get("orgCombo").toString()) ){
			level = CommissionConstants.COMIS_CD_CD_LEV;
			params.put("bizType", CommissionConstants.COMIS_CD_CDN_BIZTYPE);
			params.put("level",level);
			rawList = commissionReportService.selectCodyRawData(params);
		}else if((CommissionConstants.COMIS_CD_CDC_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_CD_CD_LEV;
			params.put("bizType", CommissionConstants.COMIS_CD_CDC_BIZTYPE);
			params.put("level",level);
			rawList = commissionReportService.selectCodyRawData(params);

		}else if((CommissionConstants.COMIS_CD_CM_CD).equals(params.get("orgCombo").toString()) ){
			level = CommissionConstants.COMIS_CD_CM_LEV;
			params.put("level",level);
			rawList = commissionReportService.selectCMRawData(params);
		}else if((CommissionConstants.COMIS_CD_SCM_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_CD_SCM_LEV;
			params.put("level",level);
			rawList = commissionReportService.selectCMRawData(params);
		}else if((CommissionConstants.COMIS_CD_GCM_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_CD_GCM_LEV;
			params.put("level",level);
			rawList = commissionReportService.selectCMRawData(params);
		}



		// 데이터 리턴.
		return ResponseEntity.ok(rawList);
	}

	@RequestMapping(value = "/commissionHPResultIndex.do")
	public String commissionHpResultIndex(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("mstId", CommissionConstants.COMIS_EMP_CD);
		List<EgovMap> orgGrList = commissionReportService.selectOrgGrList(params);
		params.put("mstId", CommissionConstants.COMIS_HP_CD);
		List<EgovMap> orgList = commissionReportService.selectOrgList(params);

		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);

		model.addAttribute("searchDt", dt);
		model.addAttribute("orgGrList", orgGrList);
		model.addAttribute("orgList", orgList);

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);

		model.addAttribute("today", today);

		// 호출될 화면
		return "commission/commissionHpResultIndex";
	}

	@RequestMapping(value = "/selectHPRawData", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHPRawData(@RequestParam Map<String, Object> params, ModelMap model) {

		String dt = String.valueOf(params.get("searchDt"));
		int pvMonth = Integer.parseInt(dt.substring(0,2));
		int pvYear = Integer.parseInt(dt.substring(3));

		int sTaskID = (((pvMonth) + (pvYear) * 12) - 24157);

		params.put("taskId", sTaskID);

		List<EgovMap> rawList = null;

		String level = "0";
		if((CommissionConstants.COMIS_HP_HPP_CD).equals(params.get("orgCombo").toString()) ){
			level = CommissionConstants.COMIS_HP_HP_LEV;
			params.put("empType", CommissionConstants.COMIS_HP_HPP_EMPTYPE);

		}else if((CommissionConstants.COMIS_HP_HPF_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_HP_HP_LEV;
			params.put("empType", CommissionConstants.COMIS_HP_HPF_EMPTYPE);

		}else if((CommissionConstants.COMIS_HP_HM_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_HP_HM_LEV;

		}else if((CommissionConstants.COMIS_HP_SM_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_HP_SM_LEV;

		}else if((CommissionConstants.COMIS_HP_GM_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_HP_GM_LEV;

		}else if((CommissionConstants.COMIS_HP_SGM_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_HP_SGM_LEV;
		}

		params.put("level",level);
		rawList = commissionReportService.selectHPRawData(params);

		// 데이터 리턴.
		return ResponseEntity.ok(rawList);
	}

	@RequestMapping(value = "/commissionCTResultIndex.do")
	public String commissionCtResultIndex(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("mstId", CommissionConstants.COMIS_EMP_CD);
		List<EgovMap> orgGrList = commissionReportService.selectOrgGrList(params);
		params.put("mstId", CommissionConstants.COMIS_CT_CD);
		List<EgovMap> orgList = commissionReportService.selectOrgList(params);

		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);

		model.addAttribute("searchDt", dt);
		model.addAttribute("orgGrList", orgGrList);
		model.addAttribute("orgList", orgList);

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);

		model.addAttribute("today", today);

		// 호출될 화면
		return "commission/commissionCTResultIndex";
	}

	@RequestMapping(value = "/selectCTRawData", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCTRawData(@RequestParam Map<String, Object> params, ModelMap model) {

		String dt = String.valueOf(params.get("searchDt"));
		int pvMonth = Integer.parseInt(dt.substring(0,2));
		int pvYear = Integer.parseInt(dt.substring(3));

		int sTaskID = (((pvMonth) + (pvYear) * 12) - 24157);

		params.put("taskId", sTaskID);

		List<EgovMap> rawList = null;

		String level = "0";
		if((CommissionConstants.COMIS_CT_CTN_CD).equals(params.get("orgCombo").toString()) ){
			level = CommissionConstants.COMIS_CT_CT_LEV;

		}else if((CommissionConstants.COMIS_CT_CTE_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_CT_CT_LEV;

		}else if((CommissionConstants.COMIS_CT_CTR_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_CT_CT_LEV;

		}else if((CommissionConstants.COMIS_CT_CTL_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_CT_CTL_LEV;

		}else if((CommissionConstants.COMIS_CT_CTM_CD).equals(params.get("orgCombo").toString())){
			level = CommissionConstants.COMIS_CT_CTM_LEV;
		}

		params.put("level",level);
		rawList = commissionReportService.selectCTRawData(params);

		// 데이터 리턴.
		return ResponseEntity.ok(rawList);
	}

	/**
	 * Call Income Statement commission report
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/commissionHPIncomeStatement.do")
	public String commissionHPIncomeStatement(@RequestParam Map<String, Object> params, ModelMap model , SessionVO sessionVO) {
		Date date = new Date();
		String loginId = String.valueOf(sessionVO.getUserName());	//member code
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);

		List<EgovMap> yearList = new ArrayList <EgovMap> ();
		int year = Integer.parseInt(today.substring(4));
		int startYear = year-5 > CommissionConstants.COMIS_INCO_YEAR ?year-5:CommissionConstants.COMIS_INCO_YEAR ;

		for(int i=startYear ;i<year;i++){	//Start From 2016 Year
			EgovMap em = new EgovMap();
			em.put("cmmYear" ,String.valueOf(i));
			yearList.add(em);
		}

		model.addAttribute("yearList", yearList);
		model.addAttribute("today", today);
		model.addAttribute("loginId", loginId);
		// 호출될 화면
		return "commission/commissionHPIncomeStatement";
	}

	/**
	 * Call Income Statement commission report
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/commissionCDIncomeStatement.do")
	public String commissionMemberIncomeStatement(@RequestParam Map<String, Object> params, ModelMap model , SessionVO sessionVO) {
		Date date = new Date();
		String loginId = String.valueOf(sessionVO.getUserName());	//member code
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);

		List<EgovMap> yearList = new ArrayList <EgovMap> ();
		int year = Integer.parseInt(today.substring(4));
		int startYear = year-5 > CommissionConstants.COMIS_INCO_YEAR ?year-5:CommissionConstants.COMIS_INCO_YEAR ;

		for(int i=startYear ;i<year;i++){	//Start From 2016 Year
			EgovMap em = new EgovMap();
			em.put("cmmYear" ,String.valueOf(i));
			yearList.add(em);
		}

		model.addAttribute("yearList", yearList);
		model.addAttribute("today", today);
		model.addAttribute("loginId", loginId);
		// 호출될 화면
		return "commission/commissionCDIncomeStatement";
	}

	@RequestMapping(value = "/commissionHTReport.do")
	public String commissionHTReport(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);
		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);
		String loginId = String.valueOf(sessionVO.getUserName());	//member code

		model.addAttribute("memberType", 7);
		model.addAttribute("today", today);
		model.addAttribute("cmmDt", dt);
		model.addAttribute("loginId",loginId);

		// 호출될 화면
		return "commission/commissionHTReport";
	}

	@RequestMapping(value = "/commissionHTIncomeStatement.do")
	public String commissionHTIncomeStatement(@RequestParam Map<String, Object> params, ModelMap model , SessionVO sessionVO) {
		Date date = new Date();
		String loginId = String.valueOf(sessionVO.getUserName());	//member code
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);

		List<EgovMap> yearList = new ArrayList <EgovMap> ();
		int year = Integer.parseInt(today.substring(4));
		int startYear = year-5 > CommissionConstants.COMIS_INCO_YEAR ?year-5:CommissionConstants.COMIS_INCO_YEAR ;

		for(int i=startYear ;i<year;i++){	//Start From 2016 Year
			EgovMap em = new EgovMap();
			em.put("cmmYear" ,String.valueOf(i));
			yearList.add(em);
		}

		model.addAttribute("yearList", yearList);
		model.addAttribute("today", today);
		model.addAttribute("loginId", loginId);
		// 호출될 화면
		return "commission/commissionHTIncomeStatement";
	}

	@RequestMapping(value = "/commSHIIndexView2.do")
	public String commSHICollection2(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		String dt = CommonUtils.getCalMonth(0);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);
		String loginId = String.valueOf(sessionVO.getUserName());	//member code

		List memType = commissionReportService.commissionGroupType(params);
		model.addAttribute("memType", memType);
		model.addAttribute("today", today);
		model.addAttribute("searchDt", dt);
		model.addAttribute("loginId",loginId);

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
		  params.put("typeCode",sessionVO.getUserTypeId());
		  //params.put("memCode", sessionVO.getUserMemCode());
		  params.put("memCode", loginId); //ticket #24032866
		  params.put("pvMonth", today.substring(2,4));
		  params.put("pvYear", today.substring(4));

      Map getUserInfo =commissionReportService.commSHIMemberSearch(params);

      model.put("memCodeType", sessionVO.getUserTypeId() );
      model.put("orgCode", getUserInfo.get("ORG_CODE"));
      model.put("grpCode", getUserInfo.get("GRP_CODE"));
      model.put("deptCode", getUserInfo.get("DEPT_CODE"));
      model.put("memCode", getUserInfo.get("MEM_CODE"));
		}

		// 호출될 화면
		return "commission/commissionSHICollectionTarget2";
	}

	@RequestMapping(value = "commSPCRgenrawSHIIndex2")
	  public ResponseEntity<List> commSPCRgenrawSHIIndex2(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

	    String date = params.get("shiDate").toString();
	    String pvMonth =date.substring(0,2);
	    String pvYear=date.substring(date.indexOf("/")+1,date.length());
	    params.put("pvMonth",pvMonth);
	    params.put("pvYear",pvYear);
	    params.put("custType", params.get("custType").toString());
	    params.put("catType", params.get("catType").toString());

	    commissionReportService.commSPCRgenrawSHIIndexCall2(params);

	    List<EgovMap> list =  (List<EgovMap>) params.get("cv_1");

	    final BigDecimal ONE_HUNDRED = new BigDecimal(100);

	    String sTOPORGCODE = "";
	    String sORGCODE = "";
	    String sGRPCODE = "";
	    String sDEPTCODE = "";
	    String sHPCODE = "";

	    String nTOPORGCODE = "";
	    String nORGCODE = "";
	    String nGRPCODE = "";
	    String nDEPTCODE = "";

	    int sTOPOUNIT = 0;
	    BigDecimal sTOPOCOLLECTTARGET = null;
	    BigDecimal sTOPOCOLLECT_AMT = null;
	    BigDecimal sTOPOOUTSTDTRATE = null;

	    int sOUNIT = 0;
	    BigDecimal sOCOLLECTTARGET = null;
	    BigDecimal sOCOLLECT_AMT = null;
	    BigDecimal sOOUTSTDTRATE = null;

	    int sGUNIT = 0;
	    BigDecimal sGCOLLECTTARGET = null;
	    BigDecimal sGCOLLECT_AMT = null;
	    BigDecimal sGOUTSTDTRATE = null;

	    int sDUNIT = 0;
	    BigDecimal sDCOLLECTTARGET = null;
	    BigDecimal sDCOLLECT_AMT = null;
	    BigDecimal sDOUTSTDTRATE = null;

	    int mUNIT = 0;
	    BigDecimal mCOLLECTTARGET = null;
	    BigDecimal mCOLLECT_AMT = null;

	    List<EgovMap> tempList = null;
	    List finalList = new ArrayList();
	    EgovMap topOrgCodeMap =new EgovMap();
	    EgovMap orgCodeMap = new EgovMap();
	    EgovMap grpCodeMap =new EgovMap();
	    EgovMap deptCodeMap =new EgovMap();
	    EgovMap memberMap =new EgovMap();

	    List memberList = new ArrayList();

	    int orgSize = 0;
	    int grpSize = 0;

	    int next = 0;
	    boolean hasNext = true;

	    for(int i = 0; i< list.size(); i++){
	      next++;

	      if(next == list.size())
	        hasNext = false;

	      memberMap =new EgovMap();

	      nDEPTCODE   = hasNext ? list.get(next).get("deptCode").toString()   : null ;
	      nGRPCODE    = hasNext ? list.get(next).get("grpCode").toString()    : null ;
	      nORGCODE    = hasNext ? list.get(next).get("orgCode").toString()    : null ;
	      nTOPORGCODE = hasNext ? list.get(next).get("topOrgCode").toString() : null ;

	      sHPCODE     = list.get(i).get("memCode").toString();
	      sDEPTCODE   = list.get(i).get("deptCode").toString();
	      sGRPCODE    = list.get(i).get("grpCode").toString();
	      sORGCODE    = list.get(i).get("orgCode").toString();
	      sTOPORGCODE = list.get(i).get("topOrgCode").toString();

	      mCOLLECTTARGET = new BigDecimal(list.get(i).get("targetatmt").toString());
	      mCOLLECT_AMT   = new BigDecimal(list.get(i).get("collectamt").toString());
	      mUNIT          = Integer.parseInt(list.get(i).get("unit").toString());
	      memberMap.put("memCode",sHPCODE);
	      memberMap.put("unit",mUNIT);
	      memberMap.put("targetatmt",mCOLLECTTARGET);
	      memberMap.put("collectamt",mCOLLECT_AMT);
	      memberMap.put("collectrate", list.get(i).get("collectrate"));
	      memberList.add(memberMap);

	      sDCOLLECTTARGET = sDCOLLECTTARGET == null ? new BigDecimal(mCOLLECTTARGET.toString()) : sDCOLLECTTARGET.add(mCOLLECTTARGET);
	      sDCOLLECT_AMT = sDCOLLECT_AMT == null ? new BigDecimal(mCOLLECT_AMT.toString()): sDCOLLECT_AMT.add(mCOLLECT_AMT);
	      sDUNIT += mUNIT;

	        if(!sDEPTCODE.equals(nDEPTCODE)){

	          sDOUTSTDTRATE = sDCOLLECT_AMT.multiply(ONE_HUNDRED).divide(sDCOLLECTTARGET,2,RoundingMode.HALF_UP);

	          deptCodeMap = new EgovMap();
	          deptCodeMap.put("deptCode",sDEPTCODE);
	          deptCodeMap.put("unit",sDUNIT);
	          deptCodeMap.put("targetatmt",sDCOLLECTTARGET);
	          deptCodeMap.put("collectamt",sDCOLLECT_AMT);
	          deptCodeMap.put("collectrate",sDOUTSTDTRATE);

	          sGCOLLECTTARGET = sGCOLLECTTARGET == null ? sDCOLLECTTARGET : sGCOLLECTTARGET.add(sDCOLLECTTARGET);
	          sGCOLLECT_AMT   = sGCOLLECT_AMT == null   ? sDCOLLECT_AMT   : sGCOLLECT_AMT.add(sDCOLLECT_AMT);
	          sGUNIT += sDUNIT;
	          sGOUTSTDTRATE = sGCOLLECT_AMT.multiply(ONE_HUNDRED).divide(sGCOLLECTTARGET,2,RoundingMode.HALF_UP);

	          finalList.add(deptCodeMap);
	          finalList.addAll(memberList);

	          memberList = new ArrayList();
	          sDCOLLECTTARGET = BigDecimal.ZERO;
	          sDCOLLECT_AMT = BigDecimal.ZERO;
	          sDOUTSTDTRATE = BigDecimal.ZERO;
	          sDUNIT = 0;
	          grpSize++;
	          orgSize++;
	        }
	        grpSize++;

	        if(!sGRPCODE.equals(nGRPCODE)){
	          grpCodeMap = new EgovMap();
	          grpCodeMap.put("grpCode",sGRPCODE);

	          grpCodeMap.put("unit",sGUNIT);
	          grpCodeMap.put("targetatmt",sGCOLLECTTARGET);
	          grpCodeMap.put("collectamt",sGCOLLECT_AMT);
	          grpCodeMap.put("collectrate",sGOUTSTDTRATE);

	          sOCOLLECTTARGET = sOCOLLECTTARGET == null ? sGCOLLECTTARGET : sOCOLLECTTARGET.add(sGCOLLECTTARGET);
	          sOCOLLECT_AMT   = sOCOLLECT_AMT   == null ? sGCOLLECT_AMT   : sOCOLLECT_AMT.add(sGCOLLECT_AMT);
	          sOUNIT += sGUNIT;
	          sOOUTSTDTRATE = sOCOLLECT_AMT.multiply(ONE_HUNDRED).divide(sOCOLLECTTARGET,2,RoundingMode.HALF_UP);

	          finalList.add(finalList.size() - grpSize,grpCodeMap);

	          sGCOLLECTTARGET = BigDecimal.ZERO;
	          sGCOLLECT_AMT = BigDecimal.ZERO;
	          sGOUTSTDTRATE = BigDecimal.ZERO;
	          sGUNIT = 0;
	          grpSize = 0;
	          orgSize++;
	        }

	        orgSize++;
	        if(!sORGCODE.equals(nORGCODE)){

	          orgCodeMap = new EgovMap();
	          orgCodeMap.put("orgCode",sORGCODE);

	          orgCodeMap.put("unit",sOUNIT);
	          orgCodeMap.put("targetatmt",sOCOLLECTTARGET);
	          orgCodeMap.put("collectamt",sOCOLLECT_AMT);
	          orgCodeMap.put("collectrate",sOOUTSTDTRATE);

	          finalList.add(finalList.size() - orgSize,orgCodeMap);

	          sTOPOCOLLECTTARGET = sTOPOCOLLECTTARGET == null ? sOCOLLECTTARGET : sTOPOCOLLECTTARGET.add(sOCOLLECTTARGET);
	          sTOPOCOLLECT_AMT   = sTOPOCOLLECT_AMT   == null ? sOCOLLECT_AMT   : sTOPOCOLLECT_AMT.add(sOCOLLECT_AMT);
	          sTOPOUNIT += sOUNIT;
	          sTOPOOUTSTDTRATE = sTOPOCOLLECT_AMT.multiply(ONE_HUNDRED).divide(sTOPOCOLLECTTARGET,2,RoundingMode.HALF_UP);

	          sOCOLLECTTARGET = BigDecimal.ZERO;
	          sOCOLLECT_AMT = BigDecimal.ZERO;
	          sOOUTSTDTRATE = BigDecimal.ZERO;
	          sOUNIT = 0;
	          orgSize = 0;
	        }

	        if(!sTOPORGCODE.equals(nTOPORGCODE)){

	          topOrgCodeMap = new EgovMap();
	          topOrgCodeMap.put("topOrgCode",sTOPORGCODE);

	          topOrgCodeMap.put("unit",sTOPOUNIT);
	          topOrgCodeMap.put("targetatmt",sTOPOCOLLECTTARGET);
	          topOrgCodeMap.put("collectamt",sTOPOCOLLECT_AMT);
	          topOrgCodeMap.put("collectrate",sTOPOOUTSTDTRATE);

	          finalList.add(0,topOrgCodeMap);

	          sTOPOCOLLECTTARGET = BigDecimal.ZERO;
	          sTOPOCOLLECT_AMT = BigDecimal.ZERO;
	          sTOPOOUTSTDTRATE = BigDecimal.ZERO;
	          sTOPOUNIT = 0;
	        }
	    }

	    tempList=(List<EgovMap>)finalList;
	    return ResponseEntity.ok(tempList);
	  }

	@RequestMapping(value = "/commSHIIndexViewDetailsPop2.do")
	public String commSHIIndexViewDetailsPop2(@RequestParam Map<String, Object> params, ModelMap model) {

		String dt ="";

		if(params.get("searchDt") != null){
			dt = params.get("searchDt").toString();
		}else{
			dt = CommonUtils.getCalMonth(0);
			dt = dt.substring(4,6) + "/" + dt.substring(0, 4);
		}

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);

		model.addAttribute("today", today);
		model.addAttribute("searchDtD", dt);
		model.addAttribute("memCode", params.get("memCode"));

	  model.addAttribute("data",params);

		// 호출될 화면
		return "commission/commissionSHIIndexViewDetailPop2";
	}

	@RequestMapping(value = "commSHIDetailSearch2")
	public ResponseEntity<List<EgovMap>> commSHIDetailSearch2(@RequestParam Map<String, Object> params, ModelMap model) {

	  System.out.println(params);

	  String date = params.get("shiDate").toString();
		String pvMonth =date.substring(0,2);
		String pvYear=date.substring(date.indexOf("/")+1,date.length());
		params.put("pvMonth",pvMonth);
		params.put("pvYear",pvYear);

		commissionReportService.commSHIIndexDetailsCall2(params);
		List<EgovMap> list = (List<EgovMap>)params.get("cv_1");

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/checkDirectory.do", method = RequestMethod.GET)
	public ResponseEntity<List<Map>> checkDirectory(@RequestParam Map<String, Object> params) {

		String last = "";
		if ("PB".equals(params.get("groupCode"))) {
			last += "Public";
		} else if ("BI".equals(params.get("groupCode"))) {
            last += "BizIntel";
        } else if ("FN".equals(params.get("groupCode"))) {
            last += "Finance";
        } else {
			last += "Privacy";
		}

		// String path = uploadDir + "/RawData/" + last;
		String path = uploadDirWeb + "/RawData/" + last;

		File directory = new File(path);

		logger.debug("directory    값 : {}", directory);

		FileFilter directoryFileFilter = new FileFilter() {
			@Override
			public boolean accept(File file) {
				return file.isDirectory();
			}
		};


		File[] directoryListAsFile = directory.listFiles(directoryFileFilter);


		List<String> foldersInDirectory = new ArrayList<String>(directoryListAsFile.length);
		for (File directoryAsFile : directoryListAsFile) {
			foldersInDirectory.add(directoryAsFile.getName());
		}

		Collections.sort(foldersInDirectory);


		List<Map> list = new ArrayList<>();
		for (int i = 0; i < foldersInDirectory.size(); i++) {
			Map<String, Object> rtn = new HashMap();
			rtn.put("codeId", foldersInDirectory.get(i));
			rtn.put("codeName", foldersInDirectory.get(i));

			list.add(rtn);

		}
		logger.debug("foldersInDirectory23    값 : {}", foldersInDirectory);
		logger.debug("list    값 : {}", list);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/rawdataList.do", method = RequestMethod.GET)
	public ResponseEntity<List<Map>> rawdataList(@RequestParam Map<String, Object> params) throws Exception {

		logger.debug("groupCode : {}", params);
		// String path = uploadDir + "/RawData/" + params.get("type");
		String path = uploadDirWeb + "/RawData/" + params.get("type");
		File dirFile = new File(path);
		File[] fileList = dirFile.listFiles();
		List<Map> list = new ArrayList<>();
		for (File tempFile : fileList) {
			if (tempFile.isFile()) {
				Map<String, Object> rtn = new HashMap();
				String tempPath = tempFile.getParent();
				String tempFileName = tempFile.getName();
				logger.debug("tempPath : {}", tempPath);
				logger.debug("tempFileName : {}", tempFileName);
				File f = new File(tempPath, tempFileName);
				Date made = new Date(f.lastModified());
				Long length = f.length();
				logger.debug("made : {}", made);
				logger.debug("length : {}", length);

				rtn.put("orignlfilenm", tempFileName);
				rtn.put("updDt", made);
				rtn.put("filesize", length);
				rtn.put("subpath", tempPath);
				list.add(rtn);
			}

		}

		logger.debug("rtn : {}", list);

		return ResponseEntity.ok(list);
	}

}




