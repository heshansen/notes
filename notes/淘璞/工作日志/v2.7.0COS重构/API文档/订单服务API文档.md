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

* 对外接口：

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
|[会员订单组合优惠券查询列表（取消）](#会员订单组合优惠券查询列表)|/order/settlement/coupon-list|GET|结算页|促销服务-根据门店id查当前会员所有可用优惠券组合列表|
|[提交订单接口](#提交订单接口)|/order/settlement/submit-order|POST|结算页|商品服务-获取商品及其sku信息|
|[查当前会员各状态订单数量的接口](#查当前会员各状态订单数量的接口)|/order/member/counts|GET|我的页面|王港龙；状态包含（待付款、待发货、待收货、待自提、退款/售后）|
|[查当前会员各状态订单列表的接口](#查当前会员各状态订单列表的接口)|/order/member/list|GET|订单列表页|商品服务-获取商品及其sku信息|
|[快递订单确认收货](#快递订单确认收货)|/order/member/confirm-receipt|POST|订单列表页|王港龙|
|[取消订单接口](#取消订单接口)|/order/cancel/apply|POST|订单列表页|王港龙|
|[订单退货商品列表接口](#订单退货商品列表接口)|/order/return/member/list|GET|我的售后页|孙小东；商品服务-获取商品及其sku信息|
|[申请退货详情接口](#申请退货详情接口)|/order/return/apply/details|GET|申请退货页|孙小东；商品服务-获取商品及其sku信息|
|[提交退货申请接口](#提交退货申请接口)|/order/return/apply/submit|POST|申请退货页|孙小东；|
|[已支付退款/售后详情接口](#已支付退款/售后详情接口)|/order/cancel/details|GET|退款/售后详情页|孙小东；商品服务-获取商品及其sku信息|
|已收货退款/售后详情接口|/order/return/details|GET|退款/售后详情页|孙小东；详见[[订单服务API-v260]]的“/order/return/details”接口|
|[删除订单接口](#删除订单接口)|/order/member/delete|DELETE|订单列表页/详情页|王港龙|
|[查看订单详情接口](#查看订单详情接口)|/order/member/details|GET|订单详情页|王港龙；特别注意，待付款状态是未拆分订单，其他状态都是已拆分订单|
|[查询主订单信息接口](#查询主订单信息接口)|/order/member/parentorder-details|GET|支付选择页||
|[查自提订单列表接口](#查自提订单列表接口)|/order/extraction/list|GET|支付成功页|商品服务-获取商品及其sku信息|
|[查看自提订单二维码信息接口](#查看自提订单二维码信息接口)|/order/extraction/qr-code-info|GET|自提页|商品服务-获取商品及其sku信息|
|[查看自提订单状态接口](#查看自提订单状态接口)|/order/extraction/check-status|GET|自提页||

* 对内接口：

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
```

##### 【输出结果】

* 返回示例：

```
{
    "cartSeq": 1037,
    "totalAmount": 0,
    "payAmount": 0,
    "promotionAmount": 0,
    "selectedNum": 0,
    "totalNum": 1,
    "shoppingCartBrandshopList": [
        {
            "promotion": {
                "name": null,
                "startDate": null,
                "endDate": null,
                "level": null,
                "initiatorSeq": null,
                "mode": null,
                "entity": null,
                "promotionInfo": null,
                "remark": null,
                "promotionPrice": null,
                "promotionTargetType": null,
                "fallback": "促销服务-根据商品id和门店id查门店促销异常"
            },
            "brandshopSeq": null,
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
            "promotionPrice": 0,
            "deliveryPromotionPrice": 0,
            "totalPrice": 0,
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
                        "productSeq": null,
                        "skuSeq": null,
                        "productName": null,
                        "stock": null,
                        "fileSeq": null,
                        "unitPrice": null,
                        "offerDelivery": null,
                        "attrValueList": null,
                        "fallback": "查询商品服务异常: 无法获取配单仓商品sku及其库存信息!",
                        "deliteryPrice": null,
                        "brandshopPrice": null
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
            "promotion": {//门店自提方式促销信息
                "name": null,
                "startDate": null,
                "endDate": null,
                "level": null,
                "initiatorSeq": null,
                "mode": null,
                "entity": null,
                "promotionInfo": null,
                "remark": null,
                "promotionPrice": null,
                "promotionTargetType": null,
                "fallback": "促销服务-根据门店id查门店促销异常"
            },
            "totalPrice": 0,//门店自提应付总额
            "savePrice": 0, //门店自提节省总额
            "deliveryPromotion": null,//门店快递方式促销信息
            "deliveryTotalPrice": 0,//门店快递应付总额
            "deliverySavePrice": 0, //门店快递节省总额
            "deliveryType": "1", //门店默认提货方式
            "offerDelivery": "3",//门店支持的提货方式
            "productItemList": [//门店商品列表
                {
                    "orderItemSeq": null,
                    "brandshopSeq": 133,
                    "prodSeq": null,
                    "skuSeq": 285,
                    "deliveryType": null,
                    "gift": null,
                    "unitPrice": null,
                    "discountAmount": null,
                    "number": 1,
                    "returnedNumber": 0,
                    "inReturnNumber": 0,
                    "commented": false,
                    "couponAmount": 0,
                    "merchantCouponAmount": null,
                    "integral": 0,
                    "promotionName": null,
                    "useDate": null,
                    "remark": null,
                    "itemSeq": null,
                    "productSkuDTO": {
                        "productSeq": null,
                        "skuSeq": null,
                        "productName": null,
                        "stock": null,
                        "fileSeq": null,
                        "unitPrice": null,
                        "offerDelivery": null,
                        "attrValueList": null,
                        "fallback": "查询商品服务异常: 无法获取配单仓商品sku及其库存信息!",
                        "deliteryPrice": null,
                        "brandshopPrice": null
                    },
                    "deliteryPrice": null
                }
            ]
        }
    ],
    "needInvoice": false,
    "needAddress": true,
    "memberDefaultAddress": {
        "mAddrSeq": null,
        "name": null,
        "phone": null,
        "provinceSeq": null,
        "provinceName": null,
        "citySeq": null,
        "cityName": null,
        "countrySeq": null,
        "countryName": null,
        "detailAddress": null,
        "isDefaultAddress": null,
        "memberSeq": 428,
        "fallback": "会员服务-查询会员默认收货地址异常！"
    },
    "productTotalNum": 1,//购买商品总数
    "defaultPayAmount": 0,//所有默认提货方式的应付总额
    "defaultSaveAmount": 0//所有默认提货方式的节省总额
}
```

### 会员订单组合优惠券查询列表

##### 【接口描述】

* 路由:/order/coupon/list 
* 请求方式：GET
* 说明：需要调促销服务-根据门店id查当前会员所有可用优惠券组合列表信息

##### 【输入参数】

* 请求参数为数组，数组每个对象参数如下：

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|brandshopid|long|是|门店id|
|totalPrice|String|是|

* 请求示例：

```
```

##### 【输出结果】

* 返回示例：

```
```

### 提交订单接口

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
  "unpaidCount": "1", //待付款
  "unshippedCount": "0", //待发货
  "unreceiptCount": "3", //待收货
  "unextractCount": "1", //待自提
  "afterSaleCount": "0" //退款/售后
}
```

### 查当前会员各状态订单列表的接口

##### 【接口描述】

* 路由:/order/member/list 
* 请求方式：GET
* 说明：没有状态传参时，查全部状态的订单;待付款查的是未拆分的主订单；待发货==已支付快递订单（含取消中）；待收货==已发货的订单；待自提==已支付自提订单（含取消中）；退款/售后包含已支付取消订单、退货订单

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|status|String|否|订单查询状态：0-待付款、1-待发货、2-待收货、3-待自提、5-退款/售后|
| start | 否 | 分页参数-开始位置|
| limit | 否 | 分页参数-查询条数 |

* 请求示例：

```
```

##### 【输出结果】

* 返回参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|status|String|否|订单查询状态：0-待付款|

* 返回示例（暂定，后期很大可能改进，随时沟通）：

```
{

    "count": 4,

    "data": [

        {

            "orderSeq": 1336,

            "orderId": "20160426028456",

            "splited": false,

            "status": "4",

            "deliveryType": "1",

            "totalAmount": 1998.4,

            "discountAmount": 0,

            "integralAmount": 0,

            "couponAmount": null,

            "merchantCouponAmount": 0,

            "payAmount": 1998.4,

            "companyName": null,

            "feeRate": null,

            "parentOrderId": null,

            "brandshopName": null,

            "orderItemProductSkuDTOS": [

                {

                    "orderItemSeq": 1470,

                    "prodSeq": 101,

                    "skuSeq": 387,

                    "unitPrice": 1998.4,

                    "number": 1,

                    "productSkuDTO": {

                        "productSeq": 101,

                        "skuSeq": 387,

                        "productName": "德国Kiddy守护者2代Isofix接口汽车用宝宝儿童安全座椅9个月-12岁",

                        "fileName": null,

                        "attrValueList": [

                            {

                                "skuSeq": null,

                                "attrSeq": 537,

                                "attrName": "颜色",

                                "attrValue": "灰色",

                                "type": null,

                                "fileSeq": null,

                                "price": null,

                                "selectedAttrValue": null,

                                "invalidAttrValue": null

                            },

                            {

                                "skuSeq": null,

                                "attrSeq": 538,

                                "attrName": "适合体重",

                                "attrValue": "24-36kg",

                                "type": null,

                                "fileSeq": null,

                                "price": null,

                                "selectedAttrValue": null,

                                "invalidAttrValue": null

                            }

                        ],

                        "fallback": null

                    }

                }

            ]

        },

        {

            "orderSeq": 1337,

            "orderId": "20160426028457",

            "splited": false,

            "status": "4",

            "deliveryType": "1",

            "totalAmount": 1998.4,

            "discountAmount": 0,

            "integralAmount": 0,

            "couponAmount": null,

            "merchantCouponAmount": 0,

            "payAmount": 1998.4,

            "companyName": null,

            "feeRate": null,

            "parentOrderId": null,

            "brandshopName": null,

            "orderItemProductSkuDTOS": []

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
  "message": "取消订单申请成功！",
  "title": "成功",
  "type": "success",
  "errors": null
}
```

### 订单退货商品列表接口

##### 【接口描述】

* 路由:/order/return/member/list  
* 请求方式：GET
* 说明:查当前会员当前订单的退货商品列表

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|orderSeq|long|是|订单Seq|

* 请求示例：

```
```

##### 【输出结果】

* 返回示例：

```
{

    "count": 11,

    "data": [

        {

            "orderId": "20170110068552",

            "mobile": "18321763810",

            "number": 1,

            "status": "3",
　　　　　　　"unitPrice": null, //商品单价
            "buyNumber": null,　//购买数量
            "returneAmount": null,　//应退金额

            "productSkuDTO": {

                "productSeq": 289,

                "skuSeq": 939,

                "productName": "MQD2016夏季印花短袖T恤216220510",

                "fileSeq": 7954,

                "attrValueList": [

                    {

                        "skuSeq": null,

                        "attrSeq": 300,

                        "attrName": "颜色",

                        "attrValue": "蓝色",

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

                        "attrValue": "100（3-4岁）",

                        "type": null,

                        "fileSeq": null,

                        "price": null,

                        "selectedAttrValue": null,

                        "invalidAttrValue": null

                    }

                ],

                "fallback": null

            }

        },

        {},...

    ],

    "pageParamModel": null

}
```

### 申请退货详情接口

##### 【接口描述】

* 路由:/order/return/apply/details  
* 请求方式：GET
* 说明：

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|id|long|是|seq

* 请求示例：

```
```

##### 【输出结果】

* 返回示例：

```
{
      "orderItemSeq": 1470,

      "prodSeq": 101,

      "skuSeq": 387,

      "unitPrice": 1998.4,

      "number": 1,

      "productSkuDTO": {

          "productSeq": 101,

          "skuSeq": 387,

          "productName": "德国Kiddy守护者2代Isofix接口汽车用宝宝儿童安全座椅9个月-12岁",

          "fileName": null,

          "attrValueList": [
              {

                  "skuSeq": null,

                  "attrSeq": 537,

                  "attrName": "颜色",

                  "attrValue": "灰色",

                  "type": null,

                  "fileSeq": null,

                  "price": null,

                  "selectedAttrValue": null,

                  "invalidAttrValue": null

              },

              {

                  "skuSeq": null,

                  "attrSeq": 538,

                  "attrName": "适合体重",

                  "attrValue": "24-36kg",

                  "type": null,

                  "fileSeq": null,

                  "price": null,

                  "selectedAttrValue": null,

                  "invalidAttrValue": null

              }
        ]
    }
}
```

### 提交退货申请接口

##### 【接口描述】

* 路由:/order/return/apply/submit 
* 请求方式：POST

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|orderItemSeq|long|是|订单条目id
|invoiced|String|是|有无发票 1-有；0-无
|number|int|是|申请数量
|mobile|String|是|手机号码|
|returnType|String|是|退货方式，1-门店，2-快递
|reasonType|String|是|退货原因，1-七天无理由退货,2-我不想要了,3-拍错了/订单信息填写错误,4-商家缺货,5-商家未按时发货
|detail|String|否|问题描述
|image1|String|否|图片1文件名
|image2|String|否|图片2文件名
|image3|String|否|图片3文件名


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

### 已支付退款/售后详情接口

##### 【接口描述】

* 路由:/order/cancel/details  
* 请求方式：GET
* 说明：此接口查询已支付取消订单的退款详情；已收货申请售后的订单详情详见[[订单服务API-v260]]

##### 【输入参数】

* 请求参数

|参数名|类型|是否必须|说明|
|:------|:------|:------|:------|
|id|long|是|取消订单id（orderSeq）

* 请求示例：

```
http://localhost:8082/order/cancel/details?id=21
```

##### 【输出结果】

* 返回示例(细节较多，无法一蹴而就，暂时参考[[订单服务API-v260]]的订单详情接口“/order/details”)：

```
```


### 删除订单接口

### 查看订单详情接口

### 查询主订单信息接口

### 查自提订单列表接口

### 查看自提订单二维码信息接口

### 查看自提订单状态接口

