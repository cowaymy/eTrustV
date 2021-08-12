package com.coway.trust.web.services.servicePlanning;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.services.servicePlanning.MagicAddressService;
import com.coway.trust.web.homecare.HomecareConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/services/planning")
public class MagicAddressController {

	@Resource(name = "magicAddressService")
	private MagicAddressService magicAddressService;

	/**
	 * Magic Address 화면 호출
	 * @Author KR-SH
	 * @Date 2019. 12. 3.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/magicAddress.do")
	public String magicAddress(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
		// 호출될 화면
		return "services/servicePlanning/magicAddressList";
	}

	/**
	 * Search Magic Address
	 * @Author KR-SH
	 * @Date 2019. 12. 3.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectMagicAddress.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMagicAddress(@RequestParam Map<String, Object> params) {
		List<EgovMap> ctSubGroupList = magicAddressService.selectMagicAddress(params);

		return ResponseEntity.ok(ctSubGroupList);
	}

}
