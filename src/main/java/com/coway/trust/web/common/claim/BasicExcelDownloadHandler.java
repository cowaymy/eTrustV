package com.coway.trust.web.common.claim;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Map;

import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class BasicExcelDownloadHandler {
	private static final Logger LOGGER = LoggerFactory.getLogger(BasicExcelDownloadHandler.class);

	boolean isStarted = false;
	int totalCount = 0;
	FileWriter fileWriter;
	BufferedWriter out;

	final FileInfoVO fileInfoVO;
	final Map<String, Object> params;
	SXSSFWorkbook workbook;
	Sheet sheet;

	BasicExcelDownloadHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
		this.fileInfoVO = fileInfoVO;
		this.params = params;
		this.workbook = new SXSSFWorkbook();
		this.sheet = workbook.createSheet("Large Data");
	}

	BufferedWriter createFile() throws IOException {
		File file = new File(fileInfoVO.getFilePath() + fileInfoVO.getSubFilePath() + fileInfoVO.getTextFilename());

		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}

		fileWriter = new FileWriter(file);
		return new BufferedWriter(fileWriter);
	}

	public void close() {
//		try {
//			if (out != null) {
//				out.close();
//			}
//			if (fileWriter != null) {
//				fileWriter.close();
//			}
//		} catch (Exception ex) {
//			LOGGER.info("Ignore exception.......");
//		}

		try (FileOutputStream fileOut = new FileOutputStream(fileInfoVO.getFilePath() + fileInfoVO.getSubFilePath() +fileInfoVO.getTextFilename())) {
			workbook.write(fileOut);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				workbook.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
