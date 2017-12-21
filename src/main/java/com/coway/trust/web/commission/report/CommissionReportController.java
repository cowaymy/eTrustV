/**
 * 
 */
package com.coway.trust.web.commission.report;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
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
	
	@RequestMapping(value = "/commSHIIndexView.do")
	public String commSHICollection(@RequestParam Map<String, Object> params, ModelMap model) {
		String dt = CommonUtils.getCalMonth(0);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);
		
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);	
		
		List memType = commissionReportService.commissionGroupType(params);
		model.addAttribute("memType", memType);
		model.addAttribute("today", today);
		model.addAttribute("searchDt", dt);
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
	
	@RequestMapping(value = "commSPCRgenrawSHIIndex")
	public ResponseEntity<List> commSPCRgenrawSHIIndex(@RequestParam Map<String, Object> params, ModelMap model) {
		String date = params.get("shiDate").toString();
		String pvMonth =date.substring(0,2);
		String pvYear=date.substring(date.indexOf("/")+1,date.length());
		params.put("pvMonth",pvMonth);
		params.put("pvYear",pvYear);
		
		commissionReportService.commSPCRgenrawSHIIndexCall(params);
		
		List<EgovMap> list = (List<EgovMap>)params.get("cv_1");
		/*logger.debug("################################");
		System.out.println(list);
		logger.debug("################################");*/
		
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
				finalMap.put("targetatmt",sDCOLLECTTARGET);
				finalMap.put("collectamt",sDCOLLECT_AMT);
				finalMap.put("collectrate",sDCOLLECTTARGET > 0 ? 100 *(sDCOLLECT_AMT / sDCOLLECTTARGET) : 0);
				finalList.add(finalMap);
				
				if ( !( sGRPCODE.equals(list.get(i).get("grpCode").toString()) ) && sGUNIT > 0){
					finalMap = new EgovMap();
					finalMap.put("topOrgCode","");
					finalMap.put("orgCode","");
					finalMap.put("grpCode",sGRPCODE);
					finalMap.put("deptCode","");
					finalMap.put("memCode","");
					finalMap.put("unit",sGUNIT);
					finalMap.put("targetatmt",sGCOLLECTTARGET);
					finalMap.put("collectamt",sGCOLLECT_AMT);
					finalMap.put("collectrate",sGCOLLECTTARGET > 0 ? (100 * (sGCOLLECT_AMT / sGCOLLECTTARGET)) : 0);
					finalList.add(finalMap);
					
					if( !( sORGCODE.equals(list.get(i).get("orgCode").toString()) ) && sOUNIT > 0){
						finalMap = new EgovMap();
						finalMap.put("topOrgCode","");
						finalMap.put("orgCode",sORGCODE);
						finalMap.put("grpCode","");
						finalMap.put("deptCode","");
						finalMap.put("memCode","");
						finalMap.put("unit",sOUNIT);
						finalMap.put("targetatmt",sOCOLLECTTARGET);
						finalMap.put("collectamt",sOCOLLECT_AMT);
						finalMap.put("collectrate",sOCOLLECTTARGET > 0 ? (100 *(sOCOLLECT_AMT / sOCOLLECTTARGET)) : 0);
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
						finalMap.put("targetatmt",sTOPOCOLLECTTARGET);
						finalMap.put("collectamt",sTOPOCOLLECT_AMT);
						finalMap.put("collectrate",sTOPOCOLLECTTARGET > 0 ? (100 *(sTOPOCOLLECT_AMT / sTOPOCOLLECTTARGET)) : 0);
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
				finalMap.put("targetatmt",list.get(i).get("targetatmt"));
				finalMap.put("collectamt",list.get(i).get("collectamt"));
				Double targetatmt = list.get(i).get("targetatmt") != null ? Double.parseDouble(list.get(i).get("targetatmt").toString()) : 0;
				Double collectamt = list.get(i).get("collectamt") != null ? Double.parseDouble(list.get(i).get("collectamt").toString()) : 0;
				finalMap.put("collectrate",targetatmt > 0 ? (100 *( collectamt / targetatmt )) : 0);
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
			finalMap.put("targetatmt",sDCOLLECTTARGET);
			finalMap.put("collectamt",sDCOLLECT_AMT);
			finalMap.put("collectrate",sDCOLLECTTARGET != 0 ? (100 * (sDCOLLECT_AMT / sDCOLLECTTARGET)) : 0);
			finalList.add(finalMap);
			
			
			finalMap = new EgovMap();
			finalMap.put("topOrgCode","");
			finalMap.put("orgCode","");
			finalMap.put("grpCode",sGRPCODE);
			finalMap.put("deptCode","");
			finalMap.put("memCode","");
			finalMap.put("unit",sGUNIT);
			finalMap.put("targetatmt",sGCOLLECTTARGET);
			finalMap.put("collectamt",sGCOLLECT_AMT);
			finalMap.put("collectrate",sGCOLLECTTARGET != 0 ? (100 * (sGCOLLECT_AMT / sGCOLLECTTARGET)) : 0);
			finalList.add(finalMap);
			
			
			finalMap = new EgovMap();
			finalMap.put("topOrgCode","");
			finalMap.put("orgCode",sORGCODE);
			finalMap.put("grpCode","");
			finalMap.put("deptCode","");
			finalMap.put("memCode","");
			finalMap.put("unit",sOUNIT);
			finalMap.put("targetatmt",sOCOLLECTTARGET);
			finalMap.put("collectamt",sOCOLLECT_AMT);
			finalMap.put("collectrate",sOCOLLECTTARGET != 0 ? (100 * (sOCOLLECT_AMT / sOCOLLECTTARGET)) : 0);
			finalList.add(finalMap);
			
			
			finalMap = new EgovMap();
			finalMap.put("topOrgCode",sTOPORGCODE);
			finalMap.put("orgCode","");
			finalMap.put("grpCode","");
			finalMap.put("deptCode","");
			finalMap.put("memCode","");
			finalMap.put("unit",sTOPOUNIT);
			finalMap.put("targetatmt",sTOPOCOLLECTTARGET);
			finalMap.put("collectamt",sTOPOCOLLECT_AMT);
			finalMap.put("collectrate",sTOPOCOLLECTTARGET != 0 ? (100 * (sTOPOCOLLECT_AMT / sTOPOCOLLECTTARGET)) : 0);
			finalList.add(finalMap);
        }
		tempList=(List<EgovMap>)finalList;
		//topOrgCode=CRS0002, orgCode=CRS1012, grpCode=CRS2055, deptCode=CRS3541, memCode=545631, 
		//unit=1, targetatmt=140, collectamt=0, collectrate=0
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
		// 호출될 화면
		return "commission/commissionSHIIndexViewDetailPop";
	}
	
	@RequestMapping(value = "commSHIDetailSearch")
	public ResponseEntity<List<EgovMap>> commSHIDetailSearch(@RequestParam Map<String, Object> params, ModelMap model) {
		String date = params.get("searchDt").toString();
		String pvMonth =date.substring(0,2);
		String pvYear=date.substring(date.indexOf("/")+1,date.length());
		params.put("pvMonth",pvMonth);
		params.put("pvYear",pvYear);
		
		commissionReportService.commSHIIndexDetailsCall(params);
		List<EgovMap> list = (List<EgovMap>)params.get("cv_1");
		logger.debug("################################");
		System.out.println(list);
		logger.debug("################################");
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

		String dt = CommonUtils.getNowDate().substring(0, 6);
		dt = (Integer.parseInt(dt.substring(4))-1) + "/" + dt.substring(0, 4);
		if(dt.length()<7){
			dt = "0"+dt;
		}

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

		String dt = CommonUtils.getNowDate().substring(0, 6);
		dt = (Integer.parseInt(dt.substring(4))-1) + "/" + dt.substring(0, 4);
		if(dt.length()<7){
			dt = "0"+dt;
		}

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

		String dt = CommonUtils.getNowDate().substring(0, 6);
		dt = (Integer.parseInt(dt.substring(4))-1) + "/" + dt.substring(0, 4);
		if(dt.length()<7){
			dt = "0"+dt;
		}

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
	@RequestMapping(value = "/commissionMemberIncomeStatement.do")
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
		return "commission/commissionMemberIncomeStatement";
	}
	
}
