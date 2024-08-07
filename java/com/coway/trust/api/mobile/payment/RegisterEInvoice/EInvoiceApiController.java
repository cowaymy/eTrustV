package com.coway.trust.api.mobile.payment.RegisterEInvoice;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.login.LoginDto;
import com.coway.trust.api.mobile.payment.groupOrder.GroupOrderForm;
import com.coway.trust.biz.payment.eInvoice.service.EInvoiceApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : RegisterEInvoiceApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 1.   KR-HAN        First creation
 * </pre>
 */
@Api(value = "E-InvoiceApi", description = "E-Invoice Api")
@RestController(value = "EInvoiceApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/eInvoice")
public class EInvoiceApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EInvoiceApiController.class);

	@Resource(name = "eInvoiceApiService")
	private EInvoiceApiService eInvoiceApiService;

	@Autowired
	private MessageSourceAccessor messageAccessor;


	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 10. 1.
	 * @param registerEInvoiceForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "BillGroup List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectBillGroupList", method = RequestMethod.GET)
	public ResponseEntity<List<EInvoiceDto>>  selectBillGroupList(@ModelAttribute EInvoiceForm eInvoiceForm) throws Exception {

        Map<String, Object> params = eInvoiceForm.createMap1(eInvoiceForm);
        List<EgovMap> selectBillGroupList = null;

         // 목록 조회
        selectBillGroupList = eInvoiceApiService.selectBillGroupList(params);

        List<EInvoiceDto> eInvoiceList = selectBillGroupList.stream().map(r -> EInvoiceDto.create(r)).collect(Collectors.toList());
//        List<EInvoiceDto> eInvoiceList = null;

        return ResponseEntity.ok(eInvoiceList);
	}


	 /**
	 * selectEInvoiceDetail
	 * @Author KR-HAN
	 * @Date 2019. 10. 7.
	 * @param eInvoiceForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "E-Invoice Detail", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectEInvoiceDetail", method = RequestMethod.GET)
	public ResponseEntity<EInvoiceDto>  selectEInvoiceDetail(@ModelAttribute EInvoiceForm eInvoiceForm) throws Exception {

        Map<String, Object> params = eInvoiceForm.createMap1(eInvoiceForm);
        EgovMap selectEinvoiceDetail = null;

         // 상세 조회
        selectEinvoiceDetail = eInvoiceApiService.selectEInvoiceDetail(params);

        return ResponseEntity.ok(EInvoiceDto.create(selectEinvoiceDetail));
	}


	 /**
	 * saveEInvoiceBillType
	 * @Author KR-HAN
	 * @Date 2019. 11. 17.
	 * @param eInvoiceForm
	 * @throws Exception
	 */
	@ApiOperation(value = "Save E-Invoice Bill Type", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/saveEInvoiceBillType", method = RequestMethod.POST)
	public void saveEInvoiceBillType(@RequestBody EInvoiceForm eInvoiceForm) throws Exception {

		Map<String, Object> params = EInvoiceForm.createMap1(eInvoiceForm);

		eInvoiceApiService.saveEInvoiceBillType(params);
	}
}
