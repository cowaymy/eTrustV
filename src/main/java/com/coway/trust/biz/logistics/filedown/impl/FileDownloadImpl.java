package com.coway.trust.biz.logistics.filedown.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.filedown.FileDownloadService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("FileDownloadService")
public class FileDownloadImpl extends EgovAbstractServiceImpl implements FileDownloadService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "FileDownloadMapper")
	private FileDownloadMapper FileDownloadMapper;

	@Override
	public List<EgovMap> fileDownloadList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return FileDownloadMapper.fileDownloadList(params);
	}

	@Override
	public List<EgovMap> selectLabelList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return FileDownloadMapper.selectLabelList(params);
	}

	@Override
	public int insertFileSpace(Map<String, Object> params) {

		int fileUpId = FileDownloadMapper.fileUpCreateSeq();
		String FileExtension = ".zip";
		String FileURL = "/WebShare/FileUpload/" + Integer.toString(fileUpId) + FileExtension;

		logger.debug("fileUpId :: : {}", fileUpId);
		logger.debug("FileURL =     {}", FileURL);

		params.put("FileUpId", fileUpId);
		params.put("StatusCodeID", 1);
		params.put("FileURL", FileURL);
		params.put("FileExtension", FileExtension);

		FileDownloadMapper.insertFileSpace(params);

		return fileUpId;
	}

	@Override
	public void updateFileGroupKey(Map<String, Object> fileGroupKey) {
		// TODO Auto-generated method stub
		FileDownloadMapper.updateFileGroupKey(fileGroupKey);
	}

	@Override
	public void deleteFileSpace(Map<String, Object> params) {
		FileDownloadMapper.deleteFileSpace(params);

	}

	@Override
	public int existFileCheck(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return FileDownloadMapper.existFileCheck(params);
	}

	@Override
	public List<EgovMap> rawDataList(Map<String, Object> params) {
		// TODO Auto-generated method stub

		return FileDownloadMapper.rawDataList(params);
	}

}
