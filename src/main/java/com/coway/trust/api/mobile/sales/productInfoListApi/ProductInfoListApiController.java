package com.coway.trust.api.mobile.sales.productInfoListApi;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.productInfoListApi.ProductInfoListApiService;
import com.coway.trust.cmmn.exception.FileDownException;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovBasicLogger;
import com.coway.trust.util.EgovResourceCloseHelper;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : ProductInfoListApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "ProductInfoListApiController", description = "ProductInfoListApiController")
@RestController(value = "ProductInfoListApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/productInfoListApi")
public class ProductInfoListApiController {



	private static final Logger LOGGER = LoggerFactory.getLogger(ProductInfoListApiController.class);



	@Value("${web.resource.upload.file}")
	private String uploadDirWeb;



	@Resource(name = "ProductInfoListApiService")
	private ProductInfoListApiService productInfoListApiService;



    @ApiOperation(value = "selectCodeList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectCodeList", method = RequestMethod.GET)
    public ResponseEntity<List<ProductInfoListApiDto>> selectCodeList() throws Exception {
        List<EgovMap> selectCodeList = productInfoListApiService.selectCodeList();
        if(LOGGER.isDebugEnabled()){
            for (int i = 0; i < selectCodeList.size(); i++) {
                LOGGER.debug("selectCodeList    값 : {}", selectCodeList.get(i));
            }
        }
        return ResponseEntity.ok(selectCodeList.stream().map(r -> ProductInfoListApiDto.create(r)).collect(Collectors.toList()));
    }



	@ApiOperation(value = "selectProductInfoList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectProductInfoList", method = RequestMethod.GET)
	public ResponseEntity<List<ProductInfoListApiDto>> selectProductInfoList(@ModelAttribute ProductInfoListApiForm param) throws Exception {
		List<EgovMap> selectProductInfoList = productInfoListApiService.selectProductInfoList(param);
		if(LOGGER.isDebugEnabled()){
			for (int i = 0; i < selectProductInfoList.size(); i++) {
				LOGGER.debug("selectProductInfoList    값 : {}", selectProductInfoList.get(i));
			}
		}
		return ResponseEntity.ok(selectProductInfoList.stream().map(r -> ProductInfoListApiDto.create(r)).collect(Collectors.toList()));
	}



    /**
     * 첨부파일로 등록된 파일에 대하여 다운로드를 제공한다.
     *
     * @param params
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/fileDownProductMobil.do")
    public void fileDownProductMobil(@RequestParam Map<String, Object> params, HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        if( CommonUtils.isEmpty( (String) params.get("path") ) ){
            throw new FileDownException(AppConstants.FAIL, "Could not get file path");
        }
        String path = (String) params.get("path");
        String[] arrayPath = path.split("/");
        String newPath = "";
        String originalFileName ="";
        for( int i = 0, ii = 1 ; i < arrayPath.length ; i++, ii++){
            if( arrayPath[i].equals("WebShare") == false && CommonUtils.isNotEmpty(arrayPath[i])){
                newPath += File.separator + arrayPath[i];
            }
            if( ii == arrayPath.length ){
                originalFileName = arrayPath[i];
            }
        }


        File uFile = new File(uploadDirWeb + newPath);
        long fSize = uFile.length();

        if (fSize > 0) {
            String mimetype = "application/x-msdownload";
            response.setContentType(mimetype);
            response.setHeader("Set-Cookie", "fileDownload=true; path=/");  ///resources/js/jquery.fileDownload.js   callback 호출시 필수.
            setDisposition(originalFileName, request, response);
            BufferedInputStream in = null;
            BufferedOutputStream out = null;

            try {
                in = new BufferedInputStream(new FileInputStream(uFile));
                out = new BufferedOutputStream(response.getOutputStream());

                FileCopyUtils.copy(in, out);
                out.flush();
            } catch (IOException ex) {
                EgovBasicLogger.ignore("IO Exception", ex);
            } finally {
                EgovResourceCloseHelper.close(in, out);
            }
        } else {
            throw new FileDownException(AppConstants.FAIL, "Could not get file name : " + originalFileName);
        }
    }

    /**
     * 브라우저 구분 얻기.
     *
     * @param request
     * @return
     */
    private String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
        if (header.contains("MSIE")) {
            return "MSIE";
        } else if (header.contains("Trident")) { // IE11 문자열 깨짐 방지
            return "Trident";
        } else if (header.contains("Chrome")) {
            return "Chrome";
        } else if (header.contains("Opera")) {
            return "Opera";
        }
        return "Firefox";
    }

    /**
     * Disposition 지정하기.
     *
     * @param filename
     * @param request
     * @param response
     * @throws Exception
     */
    private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String browser = getBrowser(request);

        String dispositionPrefix = "attachment; filename=";
        String encodedFilename = null;

        if (browser.equals("MSIE")) {
            encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
        } else if (browser.equals("Trident")) { // IE11 문자열 깨짐 방지
            encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
        } else if (browser.equals("Firefox")) {
            encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
        } else if (browser.equals("Opera")) {
            encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
        } else if (browser.equals("Chrome")) {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < filename.length(); i++) {
                char c = filename.charAt(i);
                if (c > '~') {
                    sb.append(URLEncoder.encode("" + c, "UTF-8"));
                } else {
                    sb.append(c);
                }
            }
            encodedFilename = sb.toString();
        } else {
            throw new IOException("Not supported browser");
        }

        response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

        if ("Opera".equals(browser)) {
            response.setContentType("application/octet-stream;charset=UTF-8");
        }
    }
}
