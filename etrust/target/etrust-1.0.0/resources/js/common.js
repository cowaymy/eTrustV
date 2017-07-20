// Common.
var Common = {

	/**
	 * 공동으로 사용되는 Ajax 호출 함수
	 * 
	 * @param {_method}
	 *            GET, POST, PUT, DELETE
	 * @param {_url}
	 *            호출 url
	 * @param {_params}
	 *            보낼 데이터
	 * @param {_dataType}
	 *            응답받을 데이터 타입
	 * @param {_callback}
	 *            성공시 호출 할 함수
	 * @param {_errcallback}
	 *            오류시 호출 할 함수
	 * @param {_header}
	 *            같이 보낼 헤더 값(함수형)
	 */
	ajax : function(_method, _url, _jsonObj, _callback, _errcallback, _header) {

		if (_method.toLowerCase() == 'get') {
			_params = _jsonObj;
		} else {
			_params = _jsonObj ? JSON.stringify(_jsonObj) : '';
		}

		$.ajax({
			type : _method,
			url : _url,
			contentType : "application/json;charset=UTF-8",
			beforeSend : function(request) {
				if (_header) {
					_header(request);
				}
			},
			crossDomain : true,
			dataType : "json",
			data : _params,
			success : function(data, textStatus, jqXHR) {
				if (_callback) {
					_callback(data, textStatus, jqXHR);
				}
			},
			complete : function(data) {

			},
			error : function(jqXHR, textStatus, errorThrown) {

				try {
					console.log("status : " + jqXHR.status);
					console.log("code : " + jqXHR.responseJSON.code);
					console.log("message : " + jqXHR.responseJSON.message);
					console.log("detailMessage : "
							+ jqXHR.responseJSON.detailMessage);
				} catch (e) {
					console.log(e);
				}

				if (_errcallback) {
					_errcallback(jqXHR, textStatus, errorThrown);
				} else {
					alert("Fail : " + jqXHR.responseJSON.message);
				}
			}
		});
	}
};

jQuery.fn.serializeObject = function() {
	var obj = null;
	try {
		if (this[0].tagName && this[0].tagName.toUpperCase() == "FORM") {
			var arr = this.serializeArray();
			if (arr) {
				obj = {};
				jQuery.each(arr, function() {
					obj[this.name] = this.value;
				});
			}
		}
	} catch (e) {
		alert("/resource/js/common.js > serializeObject : " + e.message);
	} finally {
	}

	return obj;
};