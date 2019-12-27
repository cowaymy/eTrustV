package com.coway.trust.api.mobile.payment.invoiceApi;

import java.util.List;
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
import com.coway.trust.biz.payment.invoiceApi.InvoiceApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : InvoiceApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "InvoiceApiController", description = "InvoiceApiController")
@RestController(value = "InvoiceApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/invoiceApi")
public class InvoiceApiController {



	private static final Logger LOGGER = LoggerFactory.getLogger(InvoiceApiController.class);



	@Resource(name = "InvoiceApiService")
	private InvoiceApiService invoiceApiService;





	@ApiOperation(value = "selectInvoiceList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectInvoiceList", method = RequestMethod.GET)
	public ResponseEntity<List<InvoiceApiDto>> selectInvoiceList(@ModelAttribute InvoiceApiForm param) throws Exception {
		List<EgovMap> selectInvoiceList = invoiceApiService.selectInvoiceList(param);
		if(LOGGER.isDebugEnabled()){
			for (int i = 0; i < selectInvoiceList.size(); i++) {
				LOGGER.debug("selectInvoiceList    값 : {}", selectInvoiceList.get(i));
			}
		}
		return ResponseEntity.ok(selectInvoiceList.stream().map(r -> InvoiceApiDto.create(r)).collect(Collectors.toList()));
	}



    @ApiOperation(value = "selectRequestInvoiceList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectRequestInvoiceList", method = RequestMethod.GET)
    public ResponseEntity<List<InvoiceApiDto>> selectRequestInvoiceList(@ModelAttribute InvoiceApiForm param) throws Exception {
        List<EgovMap> selectRequestInvoiceList = invoiceApiService.selectRequestInvoiceList(param);
        if(LOGGER.isDebugEnabled()){
            for (int i = 0; i < selectRequestInvoiceList.size(); i++) {
                LOGGER.debug("selectRequestInvoiceList    값 : {}", selectRequestInvoiceList.get(i));
            }
        }
        return ResponseEntity.ok(selectRequestInvoiceList.stream().map(r -> InvoiceApiDto.create(r)).collect(Collectors.toList()));
    }



    @ApiOperation(value = "saveRequestInvoice", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/saveRequestInvoice", method = RequestMethod.POST)
    public ResponseEntity<List<InvoiceApiDto>> saveRequestInvoice(@RequestBody List<InvoiceApiDto> param) throws Exception {
        return ResponseEntity.ok(invoiceApiService.saveRequestInvoice(param));
    }



    @ApiOperation(value = "saveRequestAdvanceInvoice", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/saveRequestAdvanceInvoice", method = RequestMethod.POST)
    public ResponseEntity<InvoiceApiDto> saveRequestAdvanceInvoice(@RequestBody InvoiceApiDto param) throws Exception {
        return ResponseEntity.ok(invoiceApiService.saveRequestAdvanceInvoice(param));
    }
}
