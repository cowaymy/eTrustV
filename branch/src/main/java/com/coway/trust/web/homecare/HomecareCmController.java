package com.coway.trust.web.homecare;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.HomecareCmService;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HomecareCmController.java
 * @Description : Homeccare Common Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 2.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare")
public class HomecareCmController {

	@Resource(name = "homecareCmService")
	private HomecareCmService homecareCmService;

	/**
	 * Select Homecare Branch CodeList
	 * @Author KR-SH
	 * @Date 2019. 12. 2.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectHomecareBranchCd.do")
	public ResponseEntity<List<EgovMap>> selectHomecareBranchCd(@RequestParam Map<String, Object> params) {
		String _brnchType = CommonUtils.nvl2(params.get("brnchType"), HomecareConstants.HDC_BRANCH_TYPE);
		params.put("brnchType", _brnchType);

		List<EgovMap> branchList = homecareCmService.selectHomecareBranchCd(params);

		return ResponseEntity.ok(branchList);
	}


	/**
	 * Select Homecare Branch List
	 * @Author KR-SH
	 * @Date 2019. 12. 2.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectHomecareBranchList.do")
	public ResponseEntity<List<EgovMap>> selectHomecareBranchList(@RequestParam Map<String, Object> params) {
		String _brnchType = CommonUtils.nvl2(params.get("brnchType"), HomecareConstants.HDC_BRANCH_TYPE);
		params.put("brnchType", _brnchType);

		List<EgovMap> branchList = homecareCmService.selectHomecareBranchList(params);

		return ResponseEntity.ok(branchList);
	}

}



