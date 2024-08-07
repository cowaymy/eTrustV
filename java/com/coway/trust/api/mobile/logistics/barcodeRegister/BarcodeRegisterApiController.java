package com.coway.trust.api.mobile.logistics.barcodeRegister;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.barcodeRegister.BarcodeRegisterApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : BarcodeRegisterApiController.java
 * @Description : 모바일 바코드 등록
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 17.   KR-HAN        First creation
 * </pre>
 */
@Api(value = "barcode Register api", description = "barcode Register api")
@RestController(value = "barcodeRegisterApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/barcodeRegister")
public class BarcodeRegisterApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(BarcodeRegisterApiController.class);

	@Resource(name = "barcodeRegisterApiService")
	private BarcodeRegisterApiService barcodeRegisterApiService;

	 /**
	 * 바코드 리스트
	 * @Author KR-HAN
	 * @Date 2019. 12. 17.
	 * @param RdcStockListForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "Barcode Register List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectBarcodeRegisterList", method = RequestMethod.GET)
	public ResponseEntity<List<BarcodeRegisterApiDto>> selectBarcodeRegisterList(@ModelAttribute BarcodeRegisterApiForm barcodeRegisterApiForm)
			throws Exception {

		Map<String, Object> params = BarcodeRegisterApiForm.createMap(barcodeRegisterApiForm);

		List<EgovMap> BarcodeRegisterList = barcodeRegisterApiService.selectBarcodeRegisterList(params);

		List<BarcodeRegisterApiDto> list = BarcodeRegisterList.stream().map(r -> BarcodeRegisterApiDto.create(r))
    				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}

	 /**
	 * saveBarcode
	 * @Author KR-HAN
	 * @Date 2019. 12. 19.
	 * @param barcodeRegisterApiForm
	 * @throws Exception
	 */
	@ApiOperation(value = "save Barcode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/saveBarcode", method = RequestMethod.POST)
	public void saveBarcode(@RequestBody BarcodeRegisterApiForm barcodeRegisterApiForm) throws Exception {

		LOGGER.debug("++++ saveBarcode barcodeRegisterApiForm ::" + barcodeRegisterApiForm );

		barcodeRegisterApiService.saveBarcode(barcodeRegisterApiForm);
	}

	 /**
	 * deleteBarcode
	 * @Author KR-HAN
	 * @Date 2019. 12. 19.
	 * @param barcodeRegisterApiForm
	 * @throws Exception
	 */
	@ApiOperation(value = "save Barcode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/deleteBarcode", method = RequestMethod.POST)
	public void deleteBarcode(@RequestBody BarcodeRegisterApiForm barcodeRegisterApiForm) throws Exception {

		LOGGER.debug("++++ deleteBarcode barcodeRegisterApiForm ::" + barcodeRegisterApiForm );

		barcodeRegisterApiService.deleteBarcode(barcodeRegisterApiForm);
	}

    /**
    * AD_MOBILE_CHECK(Audit Mobile Check)
    * @Author KR-KangJaeMin
    * @Date 2019. 12. 31.
    * @param barcodeRegisterApiForm
    * @throws Exception
    */
   @ApiOperation(value = "adMobileCheckBarcode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
   @RequestMapping(value = "/adMobileCheckBarcode", method = RequestMethod.POST)
   public ResponseEntity<List<BarcodeRegisterApiForm>> adMobileCheckBarcode(@RequestBody BarcodeRegisterApiForm barcodeRegisterApiForm) throws Exception {
       return ResponseEntity.ok(barcodeRegisterApiService.adMobileCheckBarcode(barcodeRegisterApiForm));
   }

   /**
	 * searchSerialNoByBoxNo
	 * @Author KR-HAN
	 * @Date 2019. 12. 19.
	 * @param barcodeRegisterApiForm
	 * @throws Exception
	 */
	@ApiOperation(value = "Box Barcode ", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectBarcodeByBox", method = RequestMethod.GET)
	public ResponseEntity<List<BarcodeRegisterApiDto>> selectBarcodeByBox(@ModelAttribute BarcodeRegisterApiForm barcodeRegisterApiForm) throws Exception {

		LOGGER.debug("++++ selectBarcodeByBox barcodeRegisterApiForm ::" + barcodeRegisterApiForm );

		Map<String, Object> params = BarcodeRegisterApiForm.createMap(barcodeRegisterApiForm);

		LOGGER.debug("++++ selectBarcodeByBox barcodeRegisterApiForm box No::" + params.get("serialNo").toString() );
		params.put("boxno", params.get("serialNo").toString());
		List<EgovMap> BarcodeRegisterList = barcodeRegisterApiService.selectBarcodeByBox(params);

		LOGGER.debug("++++ selectBarcodeByBox barcodeRegisterApiForm serialListBtBox::" + BarcodeRegisterList.size() );

		List<BarcodeRegisterApiDto> list = BarcodeRegisterList.stream().map(r -> BarcodeRegisterApiDto.create(r))
    				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
}
