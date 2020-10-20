package com.coway.trust.web.sales.mambership;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.mambership.MembershipRejoinService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/membership")
public class  MembershipRejoinController {

	private static Logger logger = LoggerFactory.getLogger(MembershipRejoinController.class);

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "membershipRejoinService")
	private MembershipRejoinService membershipRejoinService;

	@RequestMapping(value = "/membershipRejoinList.do")
	public String membershipRejoinList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){

			params.put("userId", sessionVO.getUserId());
			EgovMap result =  salesCommonService.getUserInfo(params);

			model.put("orgCode", result.get("orgCode"));
			model.put("grpCode", result.get("grpCode"));
			model.put("deptCode", result.get("deptCode"));
			model.put("memCode", result.get("memCode"));
		}

		return "sales/membership/membershipRejoinList";
	}

	@RequestMapping(value = "/selectRejoinList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectCancellationList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
        List<EgovMap> list = membershipRejoinService.selectRejoinList(params);
        return ResponseEntity.ok(list);
    }

	@RequestMapping(value = "/membershipExpiredList.do")
    public String membershipExpiredList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

	  Date date = new Date();
      SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
      String today = df.format(date);
      String dt = CommonUtils.getCalMonth(-1);
      dt = dt.substring(4,6) + "/" + dt.substring(0,4);

      model.put("today", today);
      model.put("dt", dt);

        if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){

            params.put("userId", sessionVO.getUserId());
            EgovMap result =  salesCommonService.getUserInfo(params);

            model.put("orgCode", result.get("orgCode"));
            model.put("grpCode", result.get("grpCode"));
            model.put("deptCode", result.get("deptCode"));
            model.put("memCode", result.get("memCode"));
        }

        return "sales/membership/membershipExpiredList";
    }

    @RequestMapping(value = "/selectExpiredMembershipList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectExpiredMembershipList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
        String[] arrAppType   = request.getParameterValues("listAppType");
        String[] arrExpiredPeriod   = request.getParameterValues("expiredPeriod");

        if(arrAppType != null && !CommonUtils.containsEmpty(arrAppType)) params.put("arrAppType", arrAppType);
        if(arrExpiredPeriod != null && !CommonUtils.containsEmpty(arrExpiredPeriod)){
          params.put("arrExpiredPeriod", arrExpiredPeriod);

          for (String str : arrExpiredPeriod){
            if("7".equals(str))
                params.put("expPeriod", "7");
          }
        }

        List<EgovMap> list = membershipRejoinService.selectExpiredMembershipList(params);
        return ResponseEntity.ok(list);
    }


}
