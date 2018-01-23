package com.coway.trust.api.mobile.common;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

@Api(value = "common api", description = "common api")
@RestController(value = "MobileCommonController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/common")
public class CommonApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonApiController.class);

	@Resource(name = "commonService")
	private CommonService commonService;

	@ApiOperation(value = "CommonCode All List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/codes", method = RequestMethod.GET)
	public ResponseEntity<List<CommonCodeAllDto>> getAllCommonCodes(@ModelAttribute CommonCodeAllForm commonCodeAllForm)
			throws Exception {

		Map<String, Object> params = commonCodeAllForm.createMap(commonCodeAllForm);

		List<EgovMap> commonCodes = commonService.getAllCommonCodes(params);
		List<CommonCodeAllDto> list = commonCodes.stream().map(r -> CommonCodeAllDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "CommonCode List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/{codeMasterId}/codes", method = RequestMethod.GET)
	public ResponseEntity<List<CommonCodeDto>> getCommonCodes(
			@ApiParam(value = "코드 마스터 아이디", required = true) @PathVariable int codeMasterId,
			@ModelAttribute CommonCodeForm commonCodeForm) throws Exception {

		LOGGER.debug("MasterCodeId : {}", codeMasterId);
		LOGGER.debug("codeDisab : {}", commonCodeForm.getCodeDisab());

		Map<String, Object> params = CommonCodeForm.createMap(commonCodeForm, codeMasterId);

		List<EgovMap> commonCodes = commonService.getCommonCodes(params);
		List<CommonCodeDto> list = commonCodes.stream().map(r -> CommonCodeDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "BANK List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/banks", method = RequestMethod.GET)
	public ResponseEntity<List<BankAllDto>> getBanks(@ModelAttribute BankAllForm bankAllForm) throws Exception {

		LOGGER.debug("StusCodeId : {}", bankAllForm.getStusCodeId());

		Map<String, Object> params = BankAllForm.createMap(bankAllForm);

		List<EgovMap> banks = commonService.getBanks(params);
		List<BankAllDto> list = banks.stream().map(r -> BankAllDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "Defect Code Master Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/defect/masters", method = RequestMethod.GET)
	public ResponseEntity<List<DefectMasterDto>> getDefectMasters(@ModelAttribute DefectMasterForm defectMasterForm)
			throws Exception {

		Map<String, Object> params = DefectMasterForm.createMap(defectMasterForm);
		List<EgovMap> masters = commonService.getDefectMasters(params);
		List<DefectMasterDto> list = masters.stream().map(r -> DefectMasterDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "Defect Code Detail Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/defect/details", method = RequestMethod.GET)
	public ResponseEntity<List<DefectDetailDto>> getDefectDetails(@ModelAttribute DefectDetailForm defectDetailForm)
			throws Exception {

		Map<String, Object> params = DefectDetailForm.createMap(defectDetailForm);
		List<EgovMap> details = commonService.getDefectDetails(params);
		List<DefectDetailDto> list = details.stream().map(r -> DefectDetailDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "Malfunction Reason Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/malfunction/reasons", method = RequestMethod.GET)
	public ResponseEntity<List<MalfunctionReasonDto>> getMalfunctionReasons(
			@ModelAttribute MalfunctionReasonForm malfunctionReasonForm) throws Exception {

		Map<String, Object> params = MalfunctionReasonForm.createMap(malfunctionReasonForm);
		List<EgovMap> malfunctionReasons = commonService.getMalfunctionReasons(params);
		List<MalfunctionReasonDto> list = malfunctionReasons.stream().map(r -> MalfunctionReasonDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "Malfunction Code Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/malfunction/codes", method = RequestMethod.GET)
	public ResponseEntity<List<MalfunctionCodeDto>> getMalfunctionCodes(
			@ModelAttribute MalfunctionCodeForm malfunctionCodeForm) throws Exception {

		Map<String, Object> params = MalfunctionCodeForm.createMap(malfunctionCodeForm);
		List<EgovMap> malfunctionCodes = commonService.getMalfunctionCodes(params);
		List<MalfunctionCodeDto> list = malfunctionCodes.stream().map(r -> MalfunctionCodeDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "Reason Code Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/reason/codes", method = RequestMethod.GET)
	public ResponseEntity<List<ReasonCodeDto>> getReasonCodes(@ModelAttribute ReasonCodeForm reasonCodeForm)
			throws Exception {

		Map<String, Object> params = ReasonCodeForm.createMap(reasonCodeForm);

		List<EgovMap> reasonCodes = commonService.getReasonCodes(params);
		List<ReasonCodeDto> list = reasonCodes.stream().map(r -> ReasonCodeDto.create(r)).collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "Product Master Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/product/masters", method = RequestMethod.GET)
	public ResponseEntity<List<ProductMasterDto>> getProductMasters(@ModelAttribute ProductMasterForm productMasterForm)
			throws Exception {

		Map<String, Object> params = ProductMasterForm.createMap(productMasterForm);

		List<EgovMap> productMasters = commonService.getProductMasters(params);
		List<ProductMasterDto> list = productMasters.stream().map(r -> ProductMasterDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	@ApiOperation(value = "Product Detail Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/product/details", method = RequestMethod.GET)
	public ResponseEntity<List<ProductDetailDto>> getProductDetails(@ModelAttribute ProductDetailForm productDetailForm)
			throws Exception {

		Map<String, Object> params = ProductDetailForm.createMap(productDetailForm);

		List<EgovMap> productDetails = commonService.getProductDetails(params);
		List<ProductDetailDto> list = productDetails.stream().map(r -> ProductDetailDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
}
