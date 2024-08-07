package com.coway.trust.web.homecare.services.report;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.homecare.services.as.HcASManagementListService;
import com.coway.trust.biz.services.installation.InstallationResultListService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE             PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 2019. 12. 30.   KR-JIN       First creation
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/homecare/services/install/report")
public class HcInstallationReportController {
    private static final Logger logger = LoggerFactory.getLogger(HcInstallationReportController.class);

	@Resource(name = "installationResultListService")
	private InstallationResultListService installationResultListService;

    @Resource(name = "hcASManagementListService")
    private HcASManagementListService hcASManagementListService;

    /**
     * Installation Report Do Active List
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/doActiveListPop.do")
    public String doActiveListPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

      // HomeCare Branch : SYS0005M - 5743
      //model.addAttribute("branchList", hcASManagementListService.selectHomeCareBranchWithNm());
      model.addAttribute("branchList", hcASManagementListService.getBrnchId(null));

      return "homecare/services/install/hcDoActiveListPop";
    }

    /**
     * Installation Report Installation Note Listing
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/installationNoteListingPop.do")
    public String installationNoteListingPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
        // HomeCare Branch : SYS0005M - 5743
        model.addAttribute("branchList", hcASManagementListService.getBrnchId(null));
    	return "homecare/services/install/hcInstallationNoteListingPop";
    }

    /**
     * organization transfer page
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/installationNotePop.do")
    public String installationNotePop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
      List<EgovMap> instTypeList = installationResultListService.selectInstallationType();
      List<EgovMap> installStatus = installationResultListService.selectInstallStatus();

      logger.debug("===========================installationNotePop.do=====================================");
      logger.debug(" INSTALLATION TYPE : {}", instTypeList);
      logger.debug(" INSTALLATION STATUS : {}", installStatus);
      logger.debug("===========================installationNotePop.do=====================================");

      // HomeCare Branch : SYS0005M - 5743
      model.addAttribute("branchList", hcASManagementListService.selectHomeCareBranchWithNm());

      model.addAttribute("instTypeList", instTypeList);
      model.addAttribute("installStatus", installStatus);
      return "homecare/services/install/hcInstallationNotePop";
    }

    /**
     * Installation Report Installation Log Book Listing
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/installationLogBookPop.do")
    public String installationLogBookPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
      // HomeCare Branch : SYS0005M - 5743
      model.addAttribute("branchList", hcASManagementListService.selectHomeCareBranchWithNm());

      return "homecare/services/install/hcInstallationLogBookListingPop";
    }

    /**
     * Installation Report Installation Raw Data
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/installationRawDataPop.do")
    public String installationRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
      // 호출될 화면
      return "homecare/services/install/hcInstallationRawDataPop";
    }

    /**
     * Installation Report Installation Free Gift List
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/installationFreeGiftListPop.do")
    public String installationFreeGiftListPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
        // HomeCare Branch : SYS0005M - 5743
    	model.addAttribute("branchList", hcASManagementListService.selectHomeCareBranchWithNm());

       return "homecare/services/install/hcInstallationFreeGiftListPop";
    }

    /**
     * Installation Report Do Active List
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/dailyDscReportPop.do")
    public String dailyDscReportPop(@RequestParam Map<String, Object> params, ModelMap model) {
      // 호출될 화면
      return "services/installation/dailyDscReportPop";
    }

    /**
     * Installation Report Installation Free Gift List
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/installationDscReportPop.do")
    public String installationDscReportPop(@RequestParam Map<String, Object> params, ModelMap model) {
      // 호출될 화면
      return "services/installation/dscReportDataPop";
    }

    /**
     * Installation Report Installation Accessories Raw Data
     *
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/hcInstallationAccessoriesRawPop.do")
    public String hcInstallationAccessoriesRawPop(@RequestParam Map<String, Object> params, ModelMap model) {
      // 호출될 화면
      return "homecare/services/install/hcInstallationAccessoriesRawPop";
    }



}
