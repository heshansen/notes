# 订单服务API-v270

## 一、统一说明

* 接口负责人：贺汕森

* 往期订单服务接口API参考：[[订单服务API-v260]]

* 成功返回HTTP 状态码：除接口特殊说明外，统一为200.

* 失败统一返回数据结构

```
{
  "message": "XXXX",
  "title": "XXX",
  "type": "error/info/warning/success",
  "errors": ["error1","error2","error3",...] //错误信息列表（默认null）
}
```

* 字段名称(请求参数和返回数据)参考：[TopBaby数据库梳理(全量)](https://project.91topbaby.com/projects/topbaby/wiki/TopBaby%E6%95%B0%E6%8D%AE%E5%BA%93%E6%A2%B3%E7%90%86)

## 二、接口汇总表

### 对外接口：

|接口描述|接口路由|请求方式|所属页面|关联服务与备注|
|:------|:------|:------|:------|:------|
|[添加购物车接口](#添加购物车接口)|/order/shoppingcart/add|POST|商品详情页|账户服务-获取当前登录会员信息(下同-所有)|
|[查看购物车列表接口](#查看购物车列表接口)|/order/shoppingcart/list|GET|购物车页|商品服务-获取商品及其sku信息|
|[查购物车商品数量的接口](#查购物车商品数量的接口)|/order/shoppingcart/count|GET|我的页面||
|[修改购物车商品数量接口](#修改购物车商品数量接口)|/order/shoppingcart-item/update-productnum|PUT|购物车页||
|[批量更新购物车商品是否选中接口](#批量更新购物车商品是否选中接口)|/order/shoppingcart-item/batchupdate|PUT|购物车页||
|[删除购物车商品接口](#删除购物车商品接口)|/order/shoppingcart-item/delete|DELETE|购物车页||
|[清除购物车商品接口](#清除购物车商品接口)|/order/shoppingcart-item/batchdelete|DELETE|购物车页||
|[结算详情接口](#结算详情接口)|/order/settlement/details|GET| 结算页|商品服务－根据门店id和商品skuid查商品sku详情；促销服务－根据门店ｉｄ查门店促销信息；|
|[结算页切换门店提货方式接口](#结算页切换门店提货方式接口)|/order/settlement/details/switch-delivery|结算页||
|[提交订单接口](#提交订单接口)|/order/settlement/submit-order|POST|结算页|商品服务-获取商品及其sku信息|
|[查当前会员各状态订单数量的接口](#查当前会员各状态订单数量的接口)|/order/member/counts|GET|我的页面|王港龙；状态包含（待付款、待发货、待收货、待自提、退款/售后）|
|[查当前会员各状态订单列表的接口](#查当前会员各状态订单列表的接口)|/order/member/list|GET|订单列表页|商品服务-获取商品及其sku信息|
|[快递订单确认收货](#快递订单确认收货)|/order/member/confirm-receipt|POST|订单列表页|王港龙|
|[取消订单接口](#取消订单接口)|/order/cancel/apply|POST|订单列表页|王港龙|
|[订单退货商品列表接口](#订单退货商品列表接口)|/order/return/member/list|GET|我的售后页|孙小东；商品服务-获取商品及其sku信息|
|[申请退货详情接口](#申请退货详情接口)|/order/return/apply/details|GET|申请退货页|孙小东；商品服务-获取商品及其sku信息|
|[提交退货申请接口](#提交退货申请接口)|order/return/apply/submit|POST|申请退货页|孙小东；|
|[退款售后详情接口](#退款售后详情接口)|/order/member/after-sale/details|GET|退款/售后详情页|孙小东；商品服务-获取商品及其sku信息|
|[删除订单接口](#删除订单接口)|/order/member/delete|DELETE|订单列表页/详情页|王港龙|
|[查看订单详情接口](#查看订单详情接口)|/order/member/details|GET|订单详情页|王港龙；特别注意，待付款状态是未拆分订单，其他状态都是已拆分订单|
|[查询主订单信息接口](#查询主订单信息接口)|/order/member/payorder-details|GET|支付选择页||
|[订单支付结果详情接口](#订单支付结果详情接口)|/order/settlement/payresult/details|GET|支付结果页||
|[查看自提订单二维码信息接口](#查看自提订单二维码信息接口)|/order/member/selfpickup/qrcode|GET|自提页|商品服务-获取商品及其sku信息|
|[查看自提订单状态接口](#查看自提订单状态接口)|/order/member/checkstatus|GET|自提页||

### 联调接口：

* 其他服务调用订单服务接口：

|接口描述|接口路由|请求方式|调用方|
|:------|:------|:------|:------|
|[订单支付结果异步处理接口](#订单支付结果异步处理接口)|/order/settlement/payresult/handler|POST|支付服务|
|[门店商品评论评价接口](#门店商品评论评价接口)|/order/comment/product/average|GET|商户服务|
|[门店导购服务和环境评价接口](#门店导购服务和环境评价接口)|/order/comment/service-environment/average|GET|商户服务|
|[门店订单销量列表查询接口](#门店订单销量列表查询接口)|/order/statistics/brandshop-sales|GET|商户服务|
|[订单基本信息接口](#订单基本信息接口)|/order/simple/details|GET|生态圈服务|

* 订单服务调用其他服务接口

|接口描述|接口路由|请求方式|提供方|参考API文档
|:------|:------|:------|:------|:------|
|根据skuSeq查商品sku详情接口|/product/getProductInfoBySku|GET|商品服务|[[商品服务相关API-v270]]|
|根据brandshopSeq和skuSeq查门店商品sku及其库存信息接口|/product/getProductInfoForWarehouse|GET|商品服务|[[商品服务相关API-v270]]
|根据brandshopSeq查门店促销信息接口|/brandshop/promotion/getPromotionByBrandshop|GET|商户服务提供|[[商户服务相关API]]
|根据mAddrSeq查询会员地址信息接口|/member/address/query|GET|会员服务|[[会员服务相关API]]
|获取当前会员相关信息接口|/member/user/current|GET|会员服务|[[会员服务相关API]]
|根据travelPersonSeq查会员出行人信息接口|/member/travel/person/query|GET|会员服务|[[会员服务相关API]]
|查优先级最高的一个积分规则接口|/integral/rule/order-gift|GET|积分服务|[[积分服务相关API]]
|根据regionSeq查区域名称接口|/common/region/area/query|GET|公共服务|[[公共服务相关API]]

## 三、接口详情

### 添加购物车接口

##### 【接口描述】

* 路由:/order/shoppingcart/add
* 请求方式：POST
* 说明：商品加入购物车时，需遵循“一笔订单，同门店商品配送方式必须一致”的原则；必须验证库存是否允许；

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|brandShopSeq|long|是|门店ID|
|productSeq|long|是|商品id|
|skuSeq|long|是|商品skuID
|productNum|int(11)|是|购买数量

* 请求示例：

```

```

##### 【输出结果】

* 返回示例：

```
{
  "message": "添加成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```

### 查看购物车列表接口

##### 【接口描述】

* 路由:/order/shoppingcart/list
* 请求方式：GET
* 说明：从商品详情页点购物车和从首页点购物车按钮，默认不传参；

##### 【输入参数】

* 请求参数：无

* 请求示例：

```
http://localhost:6002/order/shoppingcart/list
```

##### 【输出结果】

* 返回示例：

```
{
  "cartSeq": 1037,
  "totalAmount": 125.1,
  "payAmount": 100.08,
  "promotionAmount": 25.02,
  "selectedNum": 1,
  "totalNum": 1,
  "shoppingCartBrandshopList": [
    {
      "promotion": {
        "promotionSeq": 246,
        "name": "测试未提交是否可以关联三种范围",
        "startDate": 1519833600000,
        "endDate": 1527609600000,
        "level": "0",
        "initiatorSeq": null,
        "mode": "0",
        "entity": "[{\"minAmount\":\"100\",\"amount\":\"0.8\"}]",
        "status": "1",
        "scopeList": [
          {
            "brandshopSeq": 133,
            "targetType": "0",
            "targetSeqs": [
              27
            ]
          },
          {
            "brandshopSeq": 133,
            "targetType": "1",
            "targetSeqs": [
              117,
              79
            ]
          },
          {
            "brandshopSeq": 133,
            "targetType": "2",
            "targetSeqs": [
              75
            ]
          }
        ],
        "promotionInfo": "已享8折；已节省25.02元",
        "promotionPrice": 25.02,
        "remark": "满100享8折",
        "fallback": null
      },
      "brandshopSeq": 133,
      "brandshop": {
        "brandshopSeq": 133,
        "merchantSeq": 150,
        "type": "1",
        "provinceSeq": 330000,
        "citySeq": 330100,
        "countrySeq": 330101,
        "areaDetail": "杭州市湖滨区东坡路7号湖滨·银泰3层",
        "areaStr": "浙江省杭州市市辖区杭州市湖滨区东坡路7号湖滨·银泰3层",
        "lng": "120.16940892521993",
        "lat": "30.25902867268426",
        "property": "1",
        "name": "1001夜杭州旗舰店",
        "businessScope": "婴童消费品",
        "telNo": "12345678910",
        "email": "1001ye@163.com",
        "fax": "6666666",
        "brandshopResp": "朱文东",
        "belongMarket": "",
        "image": 4826,
        "realImage": 4824,
        "businessLicImage": 4825,
        "businessStartTime": "10:00",
        "businessEndTime": "22:00",
        "remark": "",
        "status": "0",
        "createTime": null,
        "updateTime": null,
        "telAreaCode": "021"
      },
      "promotionPrice": 25.02,
      "deliveryPromotionPrice": 0,
      "totalPrice": 100.08,
      "deliveryTotalPrice": 0,
      "offerDelivery": "3",
      "deliveryType": "1",
      "itemProductList": [
        {
          "cartItemSeq": 3977,
          "cartSeq": 1037,
          "brandShopSeq": 133,
          "productSeq": 76,
          "skuSeq": 285,
          "productNum": 1,
          "isSelected": "1",
          "createDate": 1515067023000,
          "updateDate": 1515067072000,
          "productSkuDTO": {
            "productSeq": 76,
            "catSeq": 101,
            "brandSeq": 27,
            "skuSeq": 285,
            "productName": "1001夜童装 男女童棉衣服夹棉T恤 婴幼儿宝宝加棉打底衫 卡通冬装 ",
            "stock": 1,
            "fileSeq": 4835,
            "prodType": "0",
            "unitPrice": 125.1,
            "deliverPrice": 136.22,
            "brandshopPrice": 139,
            "offerDelivery": "3",
            "attrValueList": [
              {
                "skuSeq": null,
                "attrSeq": 300,
                "attrName": "颜色",
                "attrValue": "红色",
                "type": null,
                "fileSeq": null,
                "price": 125.1,
                "selectedAttrValue": null,
                "invalidAttrValue": null
              },
              {
                "skuSeq": null,
                "attrSeq": 322,
                "attrName": "尺码",
                "attrValue": "90（2-3岁）",
                "type": null,
                "fileSeq": null,
                "price": 125.1,
                "selectedAttrValue": null,
                "invalidAttrValue": null
              }
            ],
            "fallback": null
          }
        }
      ]
    }
  ]
}
```

### 查购物车商品数量的接口

##### 【接口描述】

* 路由:/order/shoppingcart/count
* 请求方式：GET
* 说明：存在于两处，导航栏购物车显示数量和商品详情页购物车显示数量

##### 【输入参数】

* 请求参数：无

##### 【输出结果】

* 返回示例：

```
{
    "id": 1037,//购物车id
    "count": 1 //购物车条目总数
}
```

### 修改购物车商品数量接口

##### 【接口描述】

* 路由:/order/shoppingcart-item/update-productnum
* 请求方式：PUT
* 说明：此接口仅用来更新购物车单个商品的数量，不用于更新是否选中。

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|cartItemSeq|long|是|购物车条目id|
|productNum|int|是|商品数量|

* 请求示例：

```
```

##### 【输出结果】

* 返回示例：

```
{
  "message": "更新商品数量成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```

### 批量更新购物车商品是否选中接口

##### 【接口描述】

* 路由:/order/shoppingcart-item/batchupdate
* 请求方式：PUT
* 说明：此接口用于批量更新是否选中接口，包括单个是否选中操作，参数是个数组对象

##### 【输入参数】

* 请求参数：是一个对象数组，下面是对象的参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|cartItemSeq|long|是|购物车条目id|
|isSelected|String|是|是否选中 1-选中；0-未选中|

* 请求示例：

```
```

##### 【输出结果】

* 返回示例：

```
{
  "message": "更新成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```

### 删除购物车商品接口

##### 【接口描述】

* 路由:/order/shoppingcart-item/delete
* 请求方式：DELETE
* 说明：实际只更新状态，不删除数据。

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|cartItemSeq|long|是|购物车条目id|

* 请求示例：

```
```

##### 【输出结果】

* 返回示例：


```
{
  "message": "删除成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```

### 清除购物车商品接口 

##### 【接口描述】

* 路由:/order/shoppingcart-item/batchdelete
* 请求方式：DELETE
* 说明：批量删除购物车商品接口，参数为id数组

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|ids|long[]|是|cartItemSeq数组

* 请求示例：

```
```

##### 【输出结果】

* 返回示例：

```
{
  "message": "删除成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```

### 结算详情接口

##### 【接口描述】

* 路由:/order/settlement/details
* 请求方式：GET
* 说明：

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|paySource|String|是|支付来源，shoppingcart（从购物车支付）, direct（直接支付）);|
|brandShopSeq|long|否|门店ID|
|productSeq|long|否|商品id|
|skuSeq|long|否|商品skuID|
|productNum|int(11)|否|购买数量|

* 请求示例：

```
http://192.168.0.36:6002/order/settlement/details?paySource=shoppingcart
```

##### 【输出结果】

* 返回示例：

```
{
  "paySource": "shoppingcart",
  "brandshopGroupList": [
    {
      "brandshop": {
        "brandshopSeq": 133,
        "merchantSeq": 150,
        "type": "1",
        "provinceSeq": 330000,
        "citySeq": 330100,
        "countrySeq": 330101,
        "areaDetail": "杭州市湖滨区东坡路7号湖滨·银泰3层",
        "areaStr": "浙江省杭州市市辖区杭州市湖滨区东坡路7号湖滨·银泰3层",
        "lng": "120.16940892521993",
        "lat": "30.25902867268426",
        "property": "1",
        "name": "1001夜杭州旗舰店",
        "businessScope": "婴童消费品",
        "telNo": "12345678910",
        "email": "1001ye@163.com",
        "fax": "6666666",
        "brandshopResp": "朱文东",
        "belongMarket": "",
        "image": 4826,
        "realImage": 4824,
        "businessLicImage": 4825,
        "businessStartTime": "10:00",
        "businessEndTime": "22:00",
        "remark": "",
        "status": "0",
        "createTime": null,
        "updateTime": null,
        "telAreaCode": "021"
      },
      "promotion": {
        "promotionSeq": 246,
        "name": "测试未提交是否可以关联三种范围",
        "startDate": 1519833600000,
        "endDate": 1527609600000,
        "level": "0",
        "initiatorSeq": null,
        "mode": "0",
        "entity": "[{\"minAmount\":\"100\",\"amount\":\"0.8\"}]",
        "status": "1",
        "scopeList": [
          {
            "brandshopSeq": 133,
            "targetType": "0",
            "targetSeqs": [
              27
            ]
          },
          {
            "brandshopSeq": 133,
            "targetType": "1",
            "targetSeqs": [
              117,
              79
            ]
          },
          {
            "brandshopSeq": 133,
            "targetType": "2",
            "targetSeqs": [
              75
            ]
          }
        ],
        "promotionInfo": "已享8折；已节省25.02元",
        "promotionPrice": 25.02,
        "remark": "满100享8折",
        "fallback": null
      },
      "totalAmount": 125.1,
      "paymentPrice": 100.08,
      "savePrice": 25.02,
      "discountAmount": 25.02,
      "deliveryType": "1",
      "offerDelivery": null,
      "productItemList": [
        {
          "orderItemSeq": null,
          "brandshopSeq": 133,
          "prodSeq": 76,
          "skuSeq": 285,
          "deliveryType": "1",
          "gift": null,
          "unitPrice": 125.1,
          "discountAmount": 25.02,
          "number": 1,
          "returnedNumber": 0,
          "inReturnNumber": 0,
          "commented": false,
          "couponAmount": 0,
          "merchantCouponAmount": null,
          "integral": 0,
          "promotionName": "测试未提交是否可以关联三种范围",
          "useDate": null,
          "remark": null,
          "itemSeq": null,
          "productSkuDTO": {
            "productSeq": 76,
            "catSeq": 101,
            "brandSeq": 27,
            "skuSeq": 285,
            "productName": "1001夜童装 男女童棉衣服夹棉T恤 婴幼儿宝宝加棉打底衫 卡通冬装 ",
            "stock": 1,
            "fileSeq": 4835,
            "prodType": "0",
            "unitPrice": 125.1,
            "deliverPrice": 136.22,
            "brandshopPrice": 139,
            "offerDelivery": "3",
            "attrValueList": [
              {
                "skuSeq": null,
                "attrSeq": 300,
                "attrName": "颜色",
                "attrValue": "红色",
                "type": null,
                "fileSeq": null,
                "price": 125.1,
                "selectedAttrValue": null,
                "invalidAttrValue": null
              },
              {
                "skuSeq": null,
                "attrSeq": 322,
                "attrName": "尺码",
                "attrValue": "90（2-3岁）",
                "type": null,
                "fileSeq": null,
                "price": 125.1,
                "selectedAttrValue": null,
                "invalidAttrValue": null
              }
            ],
            "fallback": null
          }
        }
      ],
      "bsPromotionProductSet": {
        "productSeqSet": [
          76
        ],
        "selfTotalAmount": 125.1,
        "deliveryTotalAmount": 136.22
      }
    }
  ],
  "needInvoice": false,
  "needAddress": false,
  "payIntegralNumber": null,
  "memberAddress": null,
  "productItemNum": 1,
  "paymentAmount": 100.08,
  "saveAmount": 25.02,
  "totalAmount": 125.1,
  "discountAmount": 25.02,
  "topCouponAmount": null,
  "merchantCouponAmount": null
}
```

### 提交订单接口

##### 【接口描述】

* 路由:/order/settlement/submit-order
* 请求方式：POST
* 说明：提交订单接口必须以结算详情页为依托；

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|addressSeq|long|否|订单地址ID|
|payIntegralNumber|int|否|积分数|
|travelPersonSeq|long|否|门票类出行人id|
|remark|string|否|定制类与预约类的备注信息|
|useDate|Date |否 | 门票类与预约类日期|

* 请求示例：

```
http://localhost:6002/order/settlement/submit-order
requestBody=
{"travelPersonSeq":492,"useDate":1524889882000}
```

##### 【输出结果】

* 返回示例：

```
{
  "message": "提交订单成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```

### 查当前会员各状态订单数量的接口

##### 【接口描述】

* 路由:/order/member/counts
* 请求方式：GET
* 说明：需要登录才能查看订单各状态（包括待付款、待发货、待收货、待自提、退款/售后）数量

##### 【输入参数】

* 请求参数:无


##### 【输出结果】

* 返回示例：

```
{
  "unPaidCount": 0, //待付款
  "unSelfPickUpCount": 8, //待自提
  "unDeliverCount": 1, //待发货
  "unReceiptCount": 0, //待收货
  "afterSaleCount": 15 //退款/售后
}
```

### 查当前会员各状态订单列表的接口

##### 【接口描述】

* 路由:/order/member/list 
* 请求方式：GET
* 说明:接口不支持分页；待付款查的是未拆分的主订单，不支持拆分展示；待发货==已支付快递订单（含取消中）；待收货==已发货的订单；待自提==已支付自提订单（含取消中）；退款/售后包含已支付取消订单、退货订单

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|status|String|否|订单查询状态：1-全部订单；2-待付款、3-待自提、4-待发货、5-待收货、7-退款/售后|


* 请求示例：

```
http://localhost:6002/order/member/list?status=1
```

##### 【输出结果】

* 返回示例：

```
{
    "count": 4,
    "data": [
        {
            "orderSeq": 41247,
            "orderId": "20170821076416",
            "splited": true,
            "userType": "A",
            "status": "1",
            "deliveryType": "3",
            "totalAmount": 343.15,
            "discountAmount": 0,
            "integralAmount": 0,
            "couponAmount": 0,
            "merchantCouponAmount": 0,
            "payAmount": 343.15,
            "receiptTime": null,
            "companyName": null,
            "feeRate": null,
            "parentOrderId": null,
            "brandshopName": null,
            "memberMobile": "18817395116",
            "refundTime": null,
            "refundAmount": null,
            "orderItemProductSkuDTOS": [
                {
                    "orderItemSeq": 5103,
                    "prodSeq": 505,
                    "skuSeq": 1505,
                    "deliveryType": "1",
                    "unitPrice": 276,
                    "number": 1,
                    "productSkuDTO": {
                        "productSeq": null,
                        "catSeq": null,
                        "brandSeq": null,
                        "skuSeq": null,
                        "productName": null,
                        "stock": null,
                        "fileSeq": null,
                        "prodType": null,
                        "unitPrice": null,
                        "deliveryPrice": null,
                        "brandshopPrice": null,
                        "offerDelivery": null,
                        "attrValueList": null,
                        "fallback": "查询商品服务异常： 无法获取商品sku信息!"
                    },
                    "returnStatus": null,
                    "itemReturnList": null
                },
                {
                    "orderItemSeq": 5104,
                    "prodSeq": 46,
                    "skuSeq": 165,
                    "deliveryType": "2",
                    "unitPrice": 61.75,
                    "number": 1,
                    "productSkuDTO": {
                        "productSeq": null,
                        "catSeq": null,
                        "brandSeq": null,
                        "skuSeq": null,
                        "productName": null,
                        "stock": null,
                        "fileSeq": null,
                        "prodType": null,
                        "unitPrice": null,
                        "deliveryPrice": null,
                        "brandshopPrice": null,
                        "offerDelivery": null,
                        "attrValueList": null,
                        "fallback": "查询商品服务异常： 无法获取商品sku信息!"
                    },
                    "returnStatus": null,
                    "itemReturnList": null
                },
                {
                    "orderItemSeq": 5105,
                    "prodSeq": 41,
                    "skuSeq": 148,
                    "deliveryType": "1",
                    "unitPrice": 5.4,
                    "number": 1,
                    "productSkuDTO": {
                        "productSeq": null,
                        "catSeq": null,
                        "brandSeq": null,
                        "skuSeq": null,
                        "productName": null,
                        "stock": null,
                        "fileSeq": null,
                        "prodType": null,
                        "unitPrice": null,
                        "deliveryPrice": null,
                        "brandshopPrice": null,
                        "offerDelivery": null,
                        "attrValueList": null,
                        "fallback": "查询商品服务异常： 无法获取商品sku信息!"
                    },
                    "returnStatus": null,
                    "itemReturnList": null
                }
            ],
            "outOfReturnDate": false,
            "productNumber": 3
        },
        {},
        ...
    ],
    "pageParamModel": null
}
```

### 快递订单确认收货

##### 【接口描述】

* 路由:/order/member/confirm-receipt
* 请求方式：POST
* 说明：

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|orderSeq|long|是|订单Seq

* 请求示例：

```
```

##### 【输出结果】

* 返回示例：

```
{
  "message": "确认收货成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```

### 取消订单接口

##### 【接口描述】

* 路由:/order/cancel/apply
* 请求方式：POST
* 说明：未支付取消逻辑概要：1.更新订单状态为“已取消”；2.积分处理：新增会员使用积分历史记录，更新会员积分账户信息，新增积分退还记录；3.优惠券处理：更新会员优惠券账户信息，更新平台优惠券统计信息(所有平台券)，更新商户优惠券统计信息(平台共享赠送券和商户券)；4.新建会员取消订单记录。已支付取消逻辑梳理：1.更新订单状态为“取消中”；2.更新或新增取消订单记录。

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|orderSeq|long|是|订单Seq

* 请求示例：

```
http://localhost:6002/order/cancel/apply
requestBody=
{
    "orderSeq" : 11111
}
```

##### 【输出结果】

* 返回示例：

```
{
  "message": "取消订单申请成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```

### 订单退货商品列表接口

##### 【接口1描述】

* 路由: /order/return/member/list
* 请求方式：GET
* 说明（视情况，可略）：

##### 【输入参数】

* 请求参数

|参数名     |   类型  |   是否必须|  说明    |
|:---------|:--------|:---------|:---------|
|orderSeq  |long     |   是     |  订单seq|

* 请求示例：

```
http://localhost:6002/order/return/member/list?orderSeq=42149
```

##### 【输出结果】

* 输出参数（视情况，可略）

|参数名|类型|说明|
|:------|:------|:------|
|    |    |    |

* 返回示例：

```json
{
    "orderPO": {
        "orderSeq": 42149,
        "orderId": "20180327080753",//订单编号
        "splited": false,
        "parentOrderSeq": null,
        "userType": "A",
        "memberSeq": 645,
        "consigner": 769,
        "brandshopSeq": 133,
        "merchantSeq": 150,
        "deliveryType": "1",
        "totalAmount": 804.24,
        "discountAmount": 201.06,
        "integralAmount": 0,
        "couponAmount": 0,
        "merchantCouponAmount": 0,
        "payAmount": 804.24,
        "deliveryCode": "DC0000054101",
        "removed": false,
        "commentCompleted": false,
        "status": "3",//订单状态 0：未支付；1：已支付；2：已发货；3：已收货；4：已取消；5：已退货(废弃)；6：取消中；7：退货中（废弃）；C：已完成
        "needSplite": false,
        "subOrder": false,
        "needInvoice": false,
        "receiptTime": 1522135336000,//收货日期
        "returnProcessTimes": 0,
        "orderType": "0"
    },
    "orderReturnDetails": [
        {
            "orderItemSeq": 5985,
            "prodSeq": 564,
            "skuSeq": 1639,
            "unitPrice": 349.2,//单价
            "number": 2,//数量
            "status": null,//退货订单状态，0-申请审核中，1-申请已同意,2-商家已收货，3-申请已完成，4-申请拒绝（还未申请退货的状态为null）
            "productSkuDTO": {
                "productSeq": 564,
                "skuSeq": 1639,
                "productName": "1001夜风衣",//商品名称
                "stock": null,
                "fileSeq": 10578,
                "attrValueList": [
                    {
                        "attrSeq": 303,
                        "attrValue": "红色",//颜色
                    },
                    {
                        "attrSeq": 325,
                        "attrValue": "140（10-11岁）",//尺码
                    }
                ],
                "fallback": null
            }
        },
        {...}
    ]
}
```

### 申请退货详情接口

##### 【接口1描述】

* 路由: /order/return/apply/details
* 请求方式：GET
* 说明（视情况，可略）：

##### 【输入参数】

* 请求参数

|   参数名  |   类型  |   是否必须|  说明    |
|:---------|:--------|:---------|:---------|
|orderItemSeq  |long    |   是  | 订单子项seq|

* 请求示例：

```
http://localhost:6002/order/return/apply/details?orderItemSeq=5986
```

##### 【输出结果】

* 输出参数（视情况，可略）

|参数名|类型|说明|
|:------|:------|:------|
|  |  |   |

* 返回示例：

```json
{
    "mobile": "13764687527",//联系方式
    "orderItemPO": {
        "orderItemSeq": 5986,
        "brandshopSeq": 133,
        "prodSeq": 171,
        "skuSeq": 630,
        "deliveryType": "1",//退货方式，1-门店，2-快递
        "gift": 0,
        "unitPrice": 181.8,
        "discountAmount": 36.36,
        "number": 1,//商品数量
        "returnedNumber": 0,
        "inReturnNumber": 0,
        "commented": false,
        "couponAmount": 0,
        "merchantCouponAmount": 0,
        "integral": 0
    },
    "productSkuDTO": {//商品sku信息
        "productSeq": 171,
        "skuSeq": 630,
        "productName": "1001夜水孩儿皮皮牛t100童装丹尼熊蜘蛛侠2015春秋中性亲子时装 ",//商品名称
        "stock": null,
        "fileSeq": 5845,
        "attrValueList": [
            {
                "attrSeq": 298,
                "attrValue": "红色"//颜色
            },
            {
                "attrSeq": 320,
                "attrValue": "70（0.5-1岁）"//尺码
            }
        ],
        "fallback": null
    }
}
```

### 提交退货申请接口

##### 【接口1描述】

* 路由: order/return/apply/submit
* 请求方式：POST
* 说明（视情况，可略）：

##### 【输入参数】

* 请求参数

|   参数名  |   类型  |   是否必须   |  说明    |
|:-------------|:--------|:------|:-----------------|
| orderItemSeq  |  long   |  是  | 订单子项 seq      |
| invoiced      |  String |  是  | 有无发票 1-有；0-无 |
| number        |  int |  是     |        申请数量   |
| mobile        |  String |  是  |     手机号码   |
| returnType    |  String |  是  | 退货方式：1-门店，2-快递 |
| reasonType      |  String |  是  | 退货原因：1-七天无理由退货,2-我不想要了,3-拍错了/订单信息填写错误,4-商家缺货,5-商家未按时发货  |
| detail      |  String |  否  | 问题描述 |
| image1      |  String |  否  | 图片1文件名 |
| image2      |  String |  否  | 图片2文件名 |
| image3      |  String |  否  | 图片3文件名 |

* 请求示例：

```json
#### Content-Type:application/json requestBody:
{
    "orderItemSeq": 5986,
    "invoiced": "0",
    "number": 1,
    "mobile": "13764687527",
    "returnType": "1",
    "reasonType": "2",
    "detail": "xxxxxx",
    "image1": null,
    "image2": null,
    "image3": null
}
```

##### 【输出结果】

* 输出参数

|参数名|类型|说明|
|:-------|:------|:-----------------|
| message| String | 请求后的消息内容  |
| title  | String | 请求后的消息标题  |
| type   | String | 请求后的消息类型  |
| errors | String | 请求失败后的错误信息 |

* 返回示例：

```json
{
  "message": "添加成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```

### 退款售后详情接口

##### 【接口1描述】

* 路由: /order/member/after-sale/details
* 请求方式：GET
* 说明（视情况，可略）：

##### 【输入参数】

* 请求参数

|   参数名  |   类型  |   是否必须|  说明    |
|:---------|:--------|:---------|:---------|
| orderSeq  | Long    |   是  | 订单seq|

* 请求示例：

```
商品退货退款详情: http://localhost:6002/order/member/after-sale/details?orderSeq=42119
取消订单退款详情: http://localhost:6002/order/member/after-sale/details?orderSeq=42151
```

##### 【输出结果】

* 输出参数（视情况，可略）

|参数名|类型|说明|
|:------|:------|:------|
|   |   |   |

* 返回示例：

```json
{
    "returnOrderId": "20180328080905", //退款编号
    "orderSeq": 42119, //订单Seq
    "parentOrderSeq": null, //主订单号
    "orderItemSeq": 5952, //订单商品Seq
    "status": "2", //退款售后订单状态 0:退款审核中,1:商家已同意,2:商家已收货,3.退款完成,4.退款关闭
    "type": "0", //退款类型 0:商品退货退款 1:取消订单退款
    "returnType": "1", //商品返回方式，1-门店，2-快递
    "returnAddress": null, //寄送地址
    "reasonType": "1", //退货原因：1-七天无理由退货,2-我不想要了,3-拍错了/订单信息填写错误,4-商家缺货,5-商家未按时发货
    "createDate": 1517241600000, //申请时间
    "updateTime": 1517285571000, //退款时间
    "approvalTime": 1517285544000, //审核时间
    "receivedTime": 1517285572000, //收货时间
    "returnAmount": 72, //应退金额
    "payChannel": "手机招行", //支付方式（钱款去向）
    "itemProductSkuDTO": {
        "orderItemSeq": 5952,
        "prodSeq": 471,
        "skuSeq": 1361,
        "deliveryType": "1",
        "unitPrice": 90,//价格
        "number": 1,//数量
        "status": null,
        "productSkuDTO": {
            "productSeq": 471,
            "catSeq": null,
            "brandSeq": null,
            "skuSeq": 1361,
            "productName": "0110evertest1",//商品名称
            "stock": null,
            "fileSeq": 9792,//商品图片
            "prodType": null,
            "unitPrice": null,
            "deliverPrice": null,
            "brandshopPrice": null,
            "offerDelivery": null,
            "attrValueList": [
                {
                    "skuSeq": null,
                    "attrSeq": 116,
                    "attrName": "颜色",
                    "attrValue": "白色"
                },
                {
                    "skuSeq": null,
                    "attrSeq": 1133,
                    "attrName": "尺码",
                    "attrValue": "24寸"
                }
            ],
            "fallback": null
        },
        "returnStatus": null,
        "itemReturnList": null
    }
}
```

### 删除订单接口

### 查询主订单信息接口

##### 【接口描述】

* 路由:/order/member/delete
* 请求方式：DELETE
* 说明：

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|orderSeq|long|是|订单唯一seq

* 请求示例：

```
http://localhost:6002/order/member/delete
requestType = DELETE
requestBody = {"orderSeq":"396"}
Content-Type = application/json
```

##### 【输出结果】

* 返回示例：


```json
{
  "message": "删除订单成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```

### 查看订单详情接口

##### 【接口描述】

* 路由:/order/member/details
* 请求方式：GET
* 说明：全部退款完成状态未知

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|orderSeq|long|是|订单唯一id|

* 请求示例：

```
待付款：http://192.168.0.36:6002/order/member/details?orderSeq=41440
已支付：orderSeq=（731：普通自提商品；3411：普通快递商品；3407：门票类商品；3475：预约商品；3412：定制商品；695：已支付取消中）
已收货：orderSeq=1173（含退货）
交易关闭：orderSeq=（1045：未支付已取消；1060：已支付已取消；41855：未支付已取消门店订单）
交易成功：orderSeq=696
```

##### 【输出结果】

* 关键参数说明

|参数名|描述|说明|
|:------|:------|:------|
|order.orderType|订单类型|0-普通商品 1-门票类商品 2-预约类商品 3-定制类商品|
|order.status|订单状态|0-待付款（未支付），1-已支付，2-已发货，3-已收货，4-交易关闭（已取消），6-取消中，C-交易成功（已完成）|
|order.userType|下单用户类型|A-会员订单 B-门店订单|

* 返回示例：

```
{
  "order": {
    "orderSeq": 731,
    "orderId": "20160113013513",
    "splited": false,
    "parentOrderSeq": null,
    "userType": "A",
    "memberSeq": 110,
    "brandshopUserId": null,
    "consigner": null,
    "brandshopSeq": 134,
    "merchantSeq": 150,
    "deliveryType": "1",
    "totalAmount": 79.2,
    "discountAmount": 0,
    "integralAmount": 0,
    "couponAmount": null,
    "merchantCouponAmount": 0,
    "payAmount": 79.2,
    "settAmount": null,
    "deliveryCode": "DC0000001555",
    "removed": false,
    "commentCompleted": false,
    "status": "1",
    "submitDate": 1452614400000,
    "submitTime": 1452671813000,
    "payDate": 1452614400000,
    "payTime": 1452671896000,
    "deliveryDate": null,
    "deliveryTime": null,
    "cancelDate": null,
    "cancelTime": null,
    "needSplite": false,
    "subOrder": false,
    "removeDate": null,
    "removeTime": null,
    "needInvoice": false,
    "deliveryFee": null,
    "receiptTime": null,
    "returnProcessTimes": 0,
    "finishDate": null,
    "finishTime": null,
    "orderType": "0"
  },
  "itemList": [
    {
      "orderItemSeq": 846,
      "prodSeq": 76,
      "skuSeq": 283,
      "deliveryType": null,
      "unitPrice": 79.2,
      "number": 1,
      "status": null,
      "useDate": null,
      "remark": null,
      "productSkuDTO": {
        "productSeq": 76,
        "catSeq": null,
        "brandSeq": null,
        "skuSeq": 283,
        "productName": "1001夜童装 男女童棉衣服夹棉T恤 婴幼儿宝宝加棉打底衫 卡通冬装 ",
        "stock": null,
        "fileSeq": 4835,
        "prodType": null,
        "unitPrice": null,
        "deliverPrice": null,
        "brandshopPrice": null,
        "offerDelivery": null,
        "attrValueList": [
          {
            "skuSeq": null,
            "attrSeq": 300,
            "attrName": "颜色",
            "attrValue": "红色",
            "type": null,
            "fileSeq": null,
            "price": null,
            "selectedAttrValue": null,
            "invalidAttrValue": null
          },
          {
            "skuSeq": null,
            "attrSeq": 322,
            "attrName": "尺码",
            "attrValue": "70（0.5-1岁）",
            "type": null,
            "fileSeq": null,
            "price": null,
            "selectedAttrValue": null,
            "invalidAttrValue": null
          }
        ],
        "fallback": null
      },
      "returnStatus": null,
      "itemReturnList": null
    }
  ],
  "brandshopName": "1001夜杭州专卖店",
  "areaDetail": "桑植路3号中国婴童用品城街铺16",
  "useDate": null,
  "remark": null,
  "orderTravelPerson": null,
  "payChannel": "快钱支付",
  "orderAddressPO": null,
  "outOfReturnDate": null,
  "productNumber": 1
}
```

### 查看自提订单二维码信息接口

##### 【接口描述】

* 路由:/order/member/selfpickup/qrcode
* 请求方式：GET

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|orderSeq|long|是|订单唯一id

* 请求示例：

```
http://localhost:6002/order/member/selfpickup/qrcode?orderSeq=151
```

##### 【输出结果】

* 返回示例：

```
{
    "orderSeq": 151,
    "payAmount": 2146.4,
    "brandshopName": "港汇广场",
    "brandshopImage": 4260,
    "deliveryCode": "151",
    "orderId": "20151106003304",
    "extractCodeUrl": "http://localhost:6002/order/receive/received?id=151"
}
```

### 查看自提订单状态接口

##### 【接口描述】

* 路由:/order/member/checkstatus
* 请求方式：GET

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|orderSeq|long|是|订单唯一id

* 请求示例：

```
http://localhost:6002/order/member/checkstatus?orderSeq=151
```

##### 【输出结果】

* 返回示例：

```
# 无机会
{
    "orderStatus": "3",
    "haveChance": false,
    "chanceId": null,
    "conditionAmount": null
}
# 有机会
{
  "orderStatus": "3",
  "haveChance": true,
  "chanceId": 918,
  "conditionAmount": 300
}
```


### 结算页切换门店提货方式接口

##### 【接口描述】

* 路由:/order/settlement/details/switch-delivery
* 请求方式：GET
* 说明：返回数据就是结算详情信息；

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|brandShopSeq|long|是|门店ID|
|deliveryType|string|是|快递方式|

* 请求示例：

```
http://localhost:6002/order/settlement/details/switch-delivery?brandshopSeq=133&deliveryType=2
```

##### 【输出结果】

* 返回示例：同[结算详情接口](#结算详情接口)

### 订单支付结果异步处理接口  

##### 【接口描述】

* 路由:/order/settlement/payresult/handler
* 请求方式：POST
* 说明：

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|payResult|String|是|支付结果:0-支付失败、且返回数据验证成功;1-支付成功、且返回数据验证成功;2-返回数据验证不成功、或者数据不正常|
|orderId|String|是|订单编号
|channel|String|是|支付渠道
|tradeId|String|否|交易号:微信-transaction_id,支付宝-trade_no，银联-queryId
|feeAmount|float|否|手续费


##### 【输出结果】

* 返回示例：

```
{
  "message": "订单支付结果处理成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```


### 订单支付结果详情接口  

##### 【接口描述】

* 路由:/order/settlement/payresult/details
* 请求方式：GET
* 说明：

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|orderId|long|是|订单编号

* 请求示例：

```
http://localhost:6002/order/settlement/payresult/details?orderId=20170821076416
```

##### 【输出结果】

* 返回示例：

```
{
    "channel": "cmb_wap",
    "payAmount": 343.15,
    "selfPickupOrderList": [
        {
            "orderSeq": 41248,
            "payAmount": 276,
            "brandshopName": "多乐米国定店",
            "brandshopImage": 9303,
            "deliveryCode": "DC0000050610",
            "orderId": "20170821076417",
            "extractCodeUrl": "http://localhost:6002/order/receive/received?id=41248"
        },
        {
            "orderSeq": 41250,
            "payAmount": 5.4,
            "brandshopName": "贝亲（上海五角场万达广场店）",
            "brandshopImage": 4387,
            "deliveryCode": "DC0000050611",
            "orderId": "20170821076419",
            "extractCodeUrl": "http://localhost:6002/order/receive/received?id=41250"
        }
    ]
}
```

### 门店商品评论评价接口  

##### 【接口描述】

* 路由:/order/comment/product/average
* 请求方式：GET
* 说明：此为联调接口，不对外暴露。

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|brandshopSeq|long|是|门店id

* 请求示例：

```
http://192.168.0.36:6002/order/comment/product/average?brandshopSeq=237
```

##### 【输出结果】

* 返回示例：

```
5
```

### 门店导购服务和环境评价接口  

##### 【接口描述】

* 路由:/order/comment/service-environment/average
* 请求方式：GET
* 说明：此为联调接口，不对外暴露。

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|brandshopSeq|long|是|门店id

* 请求示例：

```
http://192.168.0.36:6002/order/comment/service-environment/average?brandshopSeq=133
```

##### 【输出结果】

* 返回示例：

```
5
```

### 门店订单销量列表查询接口

##### 【接口描述】

* 路由:/order/statistics/brandshop-sales  
* 请求方式：GET
* 说明：此为联调接口，不对外暴露。

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|bsArray|long[]|是|门店id数组

* 请求示例：

```
http://localhost:6002/order/statistics/brandshop-sales?bsArray=133&bsArray=254
```

##### 【输出结果】

* 返回示例：

```
[
    {
        "brandshopSeq": 133,
        "sales": 438
    },
    {
        "brandshopSeq": 254,
        "sales": 225
    }
]
```

### 订单基本信息接口

##### 【接口描述】

* 路由:/order/simple/details
* 请求方式：GET
* 说明：此为联调接口，无需认证，获取订单基本信息。

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|orderSeq|long|是|订单唯一id

* 请求示例：

```
http://localhost:6002/order/simple/details?orderSeq=110
```

##### 【输出结果】

* 返回示例：

```
{
  "orderSeq": 110,
  "orderId": "20151102002501",
  "splited": false,
  "parentOrderSeq": null,
  "userType": "A",
  "memberSeq": 46,
  "brandshopUserId": null,
  "consigner": null,
  "brandshopSeq": 125,
  "merchantSeq": 148,
  "deliveryType": "1",
  "totalAmount": 312,
  "discountAmount": 0,
  "integralAmount": 0,
  "couponAmount": null,
  "merchantCouponAmount": 0,
  "payAmount": 312,
  "settAmount": null,
  "deliveryCode": "110",
  "removed": false,
  "commentCompleted": false,
  "status": "1",
  "submitDate": 1446393600000,
  "submitTime": 1446431668000,
  "payDate": null,
  "payTime": null,
  "deliveryDate": null,
  "deliveryTime": null,
  "cancelDate": null,
  "cancelTime": null,
  "needSplite": false,
  "subOrder": false,
  "removeDate": null,
  "removeTime": null,
  "needInvoice": false,
  "deliveryFee": null,
  "receiptTime": null,
  "returnProcessTimes": 0,
  "finishDate": null,
  "finishTime": null,
  "orderType": "0"
}
```